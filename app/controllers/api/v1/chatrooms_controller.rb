module Api
  class V1::ChatroomsController < V1::ChatController
    include ApplicationHelper
    before_action :set_chatroom, only: [:show, :edit, :update, :destroy, :chatroom_detail, :update_status, :get_participants, :get_media]

  def create
    @chatroom = Chatroom.create(chatroom_params)
    if @chatroom.persisted?
      @chatroom.update(created_by: current_user)
      @chatroom.chatroom_users.where(user: current_user, is_admin: true).first_or_create
    end

    respond_to do |format|
      if  @chatroom.persisted?
        format.json { render :show, status: :created }
      else
        format.json { render json: @chatroom.errors, status: :unprocessable_entity, success: false }
      end
    end

    if @chatroom.persisted?
      @chatroom.joined_user_ids.uniq.each do |user_id|
        ActionCable.server.broadcast "current_user_#{user_id}", {
          data: {
            chatroom: JSON.parse(html(@chatroom, User.find(user_id)))
          },
          event: 'chatroom_created'
        }
      end
    end
  end

  def update
    if @chatroom.update(chatroom_update_params)
      ActionCable.server.broadcast "chatrooms:#{@chatroom.id}", {
        data: {
          chatroom: JSON.parse(update_chatroom(@chatroom))
        },
        event: 'update_chatroom'
      }
      respond_to do |format|
        format.json { render :show, status: :created}
      end
    else
      respond_to do |format|
        format.json { render json: @chatroom.errors, status: :unprocessable_entity
        }
      end
    end
  end

  def destroy
    @chatroom.discard
    respond_to do |format|
      format.json { render :show }
    end
    ActionCable.server.broadcast "chatrooms:#{@chatroom.id}", {
      data: {
        chatroom: JSON.parse(update_chatroom(@chatroom))
      },
      event: "chatroom_deleted"
    }
  end

  def chatroom_detail
    @chatroom_users = @chatroom.joined_users.paginate(
      page: 1,
      per_page: 10
    ).order(
      name: :asc
    )
    @chatroom_media = @chatroom.messages.left_joins(:file_attachment).where('active_storage_attachments.id is not NULL').paginate(
      page: 1,
      per_page: 10
    ).order(
      created_at: :desc
    )
  end

  def get_participants
    @chatroom_users = Kaminari.paginate_array(@chatroom.joined_users.order(name: :asc)).page(params[:page]).per(params[:per_page])
  end

  def get_media
    @total_count = @chatroom.messages.kept.left_joins(:file_attachment).where('active_storage_attachments.id is not NULL').count
    @chatrooms = @chatroom.messages.left_joins(:file_attachment).where('active_storage_attachments.id is not NULL').order(created_at: :desc)
    @chatroom_media = Kaminari.paginate_array(@chatrooms).page(params[:page]).per(params[:per_page])
  end

  def users_list

    @users_list = current_user.friends.order(name: :asc)
    if @users_list.present?
      if params[:search].present?
        @users = Kaminari.paginate_array(@users_list.search_with_name(params[:query])).page(params[:page]).per(params[:per_page])
      else
        @users = Kaminari.paginate_array(@users_list).page(params[:page]).per(params[:per_page])
      end
    end
  end

  private

  def set_chatroom
    @chatroom = Chatroom.find(params[:id])
  end

  def chatroom_params
    params.permit(
      :name, :description, :group_image, user_ids: []
    )
  end

  def chatroom_update_params
    params.permit(
      :name, :description, :group_image
    )
  end

  def html(chatroom, current_user)
    ApplicationController.render(
      partial: 'api/v1/chatrooms/chatroom',
      locals: { chatroom: chatroom, current_user: current_user }
    )
  end

  def update_chatroom(chatroom)
    ApplicationController.render(
      partial: 'api/v1/chatrooms/update_chatroom',
      locals: { chatroom: chatroom }
    )
  end

  end
end
