module Api
  class V1::LocationsController < V1::BaseController
    def index
      locations = Location.all
      data = {
        status: true, message: '',
        data: array_serializer.new(locations, serializer: Api::V1::LocationSerializer)
      }
      render json: data, status: default_status
    end

    def search
      locations = Location.search_with_name(params[:query])
      data = {
        status: true, message: '',
        data: array_serializer.new(locations, serializer: Api::V1::LocationSerializer),
      }
      render json: data, status: default_status
    end
  end
end
