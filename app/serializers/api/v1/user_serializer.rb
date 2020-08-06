module Api
  module V1
    class UserSerializer < ActiveModel::Serializer
      attributes :id, :email, :name
      has_one :user_profile
    end
  end
end
