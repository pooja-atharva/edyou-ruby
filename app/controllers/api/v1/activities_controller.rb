module Api
  class V1::ActivitiesController < V1::BaseController
    def index
      activities = PostActivity.main_activities
      data = {
        status: true, message: '',
        data: array_serializer.new(activities, serializer: Api::V1::ActivitySerializer),
      }
      render json: data, status: default_status
    end

    def show
      activity = PostActivity.find(params[:id])
      data = {
        status: true, message: '',
        data: single_serializer.new(activity, serializer: Api::V1::ActivityDetailSerializer),
      }
      render json: data, status: default_status
    end
  end
end
