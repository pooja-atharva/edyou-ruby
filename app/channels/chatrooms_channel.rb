# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class ChatroomsChannel < ApplicationCable::Channel
  def subscribed
    if params[:room].present?
      stream_from "chatrooms:#{params[:room]}"
    else
      current_user.joined_chatrooms.each do |chatroom|
        stream_from "chatrooms:#{chatroom.id}"
      end
    end
  end

  def unsubscribed
    if params[:room].present?
      stop_stream_from "chatrooms:#{params[:room]}"
    else
      stop_all_streams
    end
  end

  def speak(msg)
    @chatroom = Chatroom.find(msg["channelId"])

    ActionCable.server.broadcast "current_user_#{current_user.id}", {
      event_params: {
        error: 'This chatroom has been archived, no new messages can be sent',
        chatroom_id: @chatroom.id
      },
      event: 'created'
    } and return if @chatroom.discarded?

    message = @chatroom.messages.new(body: msg["body"], media_type: msg["media_type"], file_url: msg["file_url"] )
    message.user_id = current_user.id
    message.save


    file_url = msg["file_url"]
    if file_url.present?
      s3 = Aws::S3::Resource.new(region: Rails.application.credentials.dig(:aws, :region))
      obj = s3.bucket(Rails.application.credentials.dig(:aws, :bucket)).object(file_url)
      params = {
        filename: File.basename(obj.key),
        content_type: obj.content_type,
        byte_size: obj.size,
        checksum: obj.etag.gsub('"',"")
      }

      blob = ActiveStorage::Blob.create_before_direct_upload!(params)
      blob.update_attributes key:file_url

      message.update(file:blob.signed_id)
      @chatroom.update(last_message: message.file.filename.to_s)
    else
      @chatroom.update(last_message: message.body)
    end
    MessageRelayJob.perform_later(message, 'created')
  end

  def get_chatrooms

    chatrooms = current_user.joined_chatrooms.order(updated_at: :desc)
    event = "all_chatrooms"

    ActionCable.server.broadcast "current_user_#{current_user.id}", {
      data: JSON.parse(chatrooms(chatrooms,current_user)),
      event: event
    }

  end

  private

  def html(partial, params)
    ApplicationController.render(
      partial: partial,
      locals: params
    )
  end

  def chatrooms(chatrooms, current_user)
    html(
      'api/v1/chatrooms/all_chatrooms',
      { chatrooms: chatrooms, current_user: current_user }
    )
  end

end
