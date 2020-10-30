module Api
  module V1
    class PostSettingSerializer < ActiveModel::Serializer
      attributes :id, :remove_datetime
      belongs_to :user, serializer: Api::V1::UserSerializer
    end
  end
end
