
module Api
  module V1
    class CommentSerializer < ActiveModel::Serializer
      attributes :id, :content, :created_at

      belongs_to :user, serializer: Api::V1::UserSerializer

    end
  end
end
