module Api
  module V1
    class FeelingSerializer < ActiveModel::Serializer
      attributes :id, :name, :emoji_symbol
    end
  end
end
