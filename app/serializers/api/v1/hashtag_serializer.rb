module Api
  module V1
    class HashtagSerializer < ActiveModel::Serializer
      attributes :id, :context
    end
  end
end
