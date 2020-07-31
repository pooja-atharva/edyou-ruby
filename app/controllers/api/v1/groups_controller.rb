module Api
  class V1::GroupsController < V1::BaseController
    before_action :validate_record, except: [:create, :index]

    def index
      groups = current_user.groups.includes(:users)
      data = {
        status: true, message: '',
        data: array_serializer.new(groups, serializer: Api::V1::GroupSerializer),
      }
      render json: data, status: default_status
    end

    def create
      group = Group.new(group_params)
      group.owner = current_user
      if group.save
        data = { status: true, message: 'Group is created successfully', data: group_data(group)}
      else
        data = { status: false, message: group.errors.full_messages.join(','), errors: group.errors.full_messages }
        @status = 422
      end
      render json: data, status: default_status
    rescue ActiveRecord::RecordNotFound
      invalid_user_response
    end

    def update
      @group.attributes = group_params
      if @group.save
        data = { status: true, message: 'Group is update successfully', data: group_data(@group)}
      else
        data = { status: false, message: @group.errors.full_messages.join(','), errors: @group.errors.full_messages }
        @status = 422
      end
      render json: data, status: default_status
    rescue ActiveRecord::RecordNotFound
      invalid_user_response
    end

    def show
      data = { status: true, message: '', data: group_data(@group)}
      render json: data, status: default_status
    end

    def destroy
      if @group.leave_group(current_user)
        data = { status: true, message: 'Group is left successfully.', data: nil}
      else
        data = { status: false, message: @group.errors.full_messages.join(','), errors: @group.errors.full_messages }
        @status = 422
      end
      render json: data, status: default_status
    end

    private

    def invalid_user_response
      data = { status: false, message: 'One of passed user is invalid', errors: ['One of passed user is invalid'] }
      render json: data, status: 422
    end

    def group_params
      params.require(:group).permit(:name, :privacy, :university, :section, :president, :vice_president, :treasure,
        :social_director, :secretary, :email, :calendar_link,  groups_users_attributes: [:id, :user_id, :admin, :_destroy])
    end

    def group_user_params
      params.require(:group).permit(user_ids: [])
    end

    def group_data(object)
      single_serializer.new(object, serializer: Api::V1::GroupSerializer)
    end

    def validate_record
      group_user = current_user.groups_users.find_by_group_id(params[:id])
      @group = group_user.try(:group)
      render json: {status: false, message: 'Group is not found.'}, status: 404 and return if group_user.nil?
      render json: {status: false, message: 'You are not authorized to manage this group'}, status: 404 unless group_user.admin?
    end

  end
end