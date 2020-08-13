module Api
  class V1::PermissionsController < V1::BaseController
    def index
      if filter_params[:reference_type]
        permissions = Permission.where(action_object: filter_params[:reference_type])
        data = {
          status: true, message: '',
          data: array_serializer.new(permissions, serializer: Api::V1::PermissionSerializer)
        }
        render json: data, status: default_status
      else
        render_unprocessable_entity('Reference type is missing.')
      end
    end

    private
    def filter_params
      params.permit(:reference_type)
    end
  end
end