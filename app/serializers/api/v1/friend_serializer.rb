module Api
  module V1
    class FriendSerializer < ActiveModel::Serializer
      attributes :id, :name
    end
  end
end
