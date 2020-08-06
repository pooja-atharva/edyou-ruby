
module Api
  module V1
    class ProfileSerializer < ActiveModel::Serializer
      def attributes(*_args)
        object.attributes.symbolize_keys
      end

    end
  end
end
