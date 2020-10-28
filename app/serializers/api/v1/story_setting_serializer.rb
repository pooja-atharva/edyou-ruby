module Api
  module V1
    class StorySettingSerializer < ActiveModel::Serializer
      attributes :id, :share_public_story, :share_mentioned_story
    end
  end
end
 