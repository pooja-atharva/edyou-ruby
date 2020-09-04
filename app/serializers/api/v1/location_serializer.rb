module Api
  module V1
    class LocationSerializer < ActiveModel::Serializer
      attributes :id, :name, :avatar_url
    end
  end
end
