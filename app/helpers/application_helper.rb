module ApplicationHelper
  def last_msg_read_at(user, chatroom)
    user.chatroom_users.find_by(chatroom_id: chatroom.id).last_read_at if user.chatroom_users.find_by(chatroom_id: chatroom.id).present?
  end

  def unread_count(user, chatroom)
    if last_msg_read_at(user, chatroom).present?
      first_record = chatroom.messages.order(updated_at: :desc).first
      if first_record.present? && first_record.user_id == user.id
        0
      else
        chatroom.messages.where.not(user_id: user.id).where('created_at > ?', last_msg_read_at(user, chatroom)).order(created_at: :desc).count
      end
    else
      chatroom.messages.where.not(user_id: user).count
    end
  end

  def user_admin_status(user, chatroom)
    chatroom_user = chatroom.chatroom_users.find_by(user_id: user.id)
    if chatroom_user.present?
      chatroom_user.is_admin
    end
  end
end
