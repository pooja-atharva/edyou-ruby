module Api
  module V1
    class FeelingSerializer < ActiveModel::Serializer
      attributes :id, :name
    end
  end
end
