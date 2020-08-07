module Api
  class V1::FeelingsController < V1::BaseController
    def index
      feelings = Feeling.all
      data = {
        status: true, message: '',
        data: array_serializer.new(feelings, serializer: Api::V1::FeelingSerializer),
      }
      render json: data, status: default_status
    end
  end
end
