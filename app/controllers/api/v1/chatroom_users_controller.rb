module Api
  class V1::ChatroomUsersController < V1::ChatController
  include ApplicationHelper
  before_action :set_chatroom

  def add_participants
    if user_admin_status(current_user, @chatroom)
      user_ids = params[:user_ids]
      if user_ids.present?
        user_ids.each do |user_id|
          @chatroom.chatroom_users.where(user_id: user_id).first_or_create.update(status: 'joined', is_admin: false)
          ActionCable.server.broadcast "current_user_#{user_id}", {
            data: {
              chatroom: JSON.parse(html(@chatroom, user_id))
            },
            event: 'chatroom_created'
          }
        end
        ActionCable.server.broadcast "chatrooms:#{@chatroom.id}", {
          data: JSON.parse(participants_detail(@chatroom, user_ids)),
          event: 'added_participants'
        }
      end
      respond_to do |format|
        format.json { render :participants, status: :created }
      end
    else
      render :json => { :errors => "You are not authorized" }
    end
  end

  def delete_participant
    if user_admin_status(current_user, @chatroom)
      if params[:user_id].present?
        chatroom_user = @chatroom.joined_chatroom_users.find_by(user_id: params[:user_id])
        if chatroom_user.present?
          chatroom_user.update(status: 'left')
          ActionCable.server.broadcast "chatrooms:#{@chatroom.id}", {
            data: JSON.parse(participant_detail(@chatroom, params[:user_id],"delete_participants")),
            event: 'deleted_participants'
          }
        end
      end

      respond_to do |format|
        format.json { render :participants }
      end
    else
      render :json => { :errors => "You are not authorized" }
    end
  end

  def add_admin_role
    if user_admin_status(current_user, @chatroom)
      if params[:user_id].present?
        @chatroom_user = @chatroom.joined_chatroom_users.find_by(user_id: params[:user_id])
        if @chatroom_user.present?
          @chatroom_user.update(is_admin: true)
          ActionCable.server.broadcast "chatrooms:#{@chatroom.id}", {
            data: JSON.parse(participant_detail(@chatroom, params[:user_id])),
            event: 'added_admin_role'
          }
        end
      end
      respond_to do |format|
        format.json { render :show, status: :created }
      end
    else
      render :json => { :errors => "You are not authorized" }
    end
  end

  def remove_admin_role
    if user_admin_status(current_user, @chatroom)
      if params[:user_id].present?
        @chatroom_user = @chatroom.joined_chatroom_users.find_by(user_id: params[:user_id])
        if @chatroom_user.present?
          @chatroom_user.update(is_admin: false)
          ActionCable.server.broadcast "chatrooms:#{@chatroom.id}", {
            data: JSON.parse(participant_detail(@chatroom, params[:user_id])),
            event: 'removed_admin_role'
          }
        end
      end
      respond_to do |format|
        format.json { render :show, status: :created }
      end
    else
      render :json => { :errors => "You are not authorized" }
    end
  end

  def destroy
    @chatroom_user = @chatroom.chatroom_users.where(user_id: current_user.id).last
    @chatroom_user.update(status: 'left') if @chatroom_user.present?
    @chatroom.chatroom_users.each do |chatroom_user|
      ActionCable.server.broadcast "current_user_#{chatroom_user.user_id}", {
        event_params: {
          sender_user_id: current_user.id,
          chatroom_id: @chatroom.id,
          user_id: chatroom_user.user_id.to_i
        },
        event: "leave_group"
      }
    end
    if !@chatroom.joined_chatroom_users.where(is_admin: true).present?
      @new_chatroom_user = @chatroom.joined_chatroom_users.order(created_at: :asc).first
      if @new_chatroom_user.present?
        @new_chatroom_user.update(is_admin: true)
        ActionCable.server.broadcast "chatrooms:#{@chatroom.id}", {
          data: JSON.parse(participant_detail(@chatroom, @new_chatroom_user.user_id)),
          event: 'added_admin_role'
        }
      end
    end
    respond_to do |format|
      format.json { render :show }
    end
  end

  private

    def set_chatroom
      @chatroom = Chatroom.find(params[:chatroom_id])
    end

    def participants_detail(chatroom, user_ids)
      participants = User.where(id: user_ids)
      ApplicationController.render(
        partial: 'api/v1/chatroom_users/participants_detail',
        locals: { chatroom: chatroom, users: participants }
      )
    end

    def participant_detail(chatroom, user_id, event="")
      participant = User.find(user_id)
      ApplicationController.render(
        partial: 'api/v1/chatroom_users/participant_detail',
        locals: { chatroom: chatroom, user: participant, event: event }
      )
    end

    def html(chatroom, current_user)
      user = User.find(current_user)
      ApplicationController.render(
        partial: 'api/v1/chatrooms/chatroom',
        locals: { chatroom: chatroom, current_user: user }
      )
    end
  end
end
