
module Api
  module V1
    class SupportTicketSerializer < ActiveModel::Serializer
      attributes :id, :email, :name, :phone, :reason, :message

    end
  end
end
