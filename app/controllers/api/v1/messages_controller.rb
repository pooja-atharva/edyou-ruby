module Api
  class V1::MessagesController < V1::ChatController

  before_action :set_chatroom, only: [:index]

  def index
    @messages = @chatroom.messages.order(updated_at: :desc)
    @chatroom_messages = Kaminari.paginate_array(@messages).page(params[:page]).per(params[:per_page])
  end

  def destroy
    @message = Message.find(params[:id])
    @message.discard
    respond_to do |format|
      format.json { render :show }
    end
    MessageRelayJob.perform_later(@message, 'deleted')
  end

  private

    def set_chatroom
      @chatroom = Chatroom.find(params[:chatroom_id])
    end
  end
end
