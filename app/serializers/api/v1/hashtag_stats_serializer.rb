module Api
  module V1
    class HashtagStatSerializer < ActiveModel::Serializer
      attributes :id, :context
    end
  end
end
