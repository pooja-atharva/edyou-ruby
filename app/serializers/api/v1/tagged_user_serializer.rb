module Api
  module V1
    class TaggedUserSerializer < ActiveModel::Serializer
      attributes :id, :email, :name
    end
  end
end
