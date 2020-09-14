module Api
  class V1::MediaItemsController < V1::BaseController

    def create
      media_item = MediaItem.new
      media_item.media_items = params[:media_items]
      if media_item.save
        render_success_response(
          { media_item: { token: media_item.media_token } }, 'Image is added successfully in event',  200
        )
      else
        render_unprocessable_entity(media_item.errors.full_messages.join(','))
      end
    rescue
      invalid_images_response
    end

    private

    def invalid_images_response
      render_unprocessable_entity('Image is invalid. Please upload valid image')
    end
  end
end