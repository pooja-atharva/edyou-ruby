module Api
  class V1::AlbumsController < V1::BaseController
    def index
      albums = current_user.albums
      data = {
        status: true, message: '',
        data: array_serializer.new(albums, serializer: Api::V1::AlbumSerializer)
      }
      render json: data, status: default_status
    end

    def create
      album = current_user.albums.new(album_params)
      album.permission = current_user.default_permission('Album') if album.permission_id.blank?
      if album.save
        data = { status: true, message: 'Album is created successfully', data: album_data(album)}
      else
        data = { status: false, message: album.errors.full_messages.join(','), errors: album.errors.full_messages }
        @status = 422
      end
      render json: data, status: default_status
    rescue ActiveRecord::RecordNotFound
      invalid_user_response
    end

    def audience
      permissions = Permission.album_permissions
      render json: { status: true, data: array_serializer.new(permissions, serializer: Api::V1::PermissionSerializer) }
    end

    private

    def album_data(object)
      single_serializer.new(object, serializer: Api::V1::AlbumSerializer)
    end

    def album_params
      params.require(:album).permit(:name, :description, :permission_id,
                                    :allow_contributors, :parent_id,
                                    :parent_type,
                                    contributors_attributes: [:user_id],
                                    access_requirement_ids: [])
    end
  end
end
