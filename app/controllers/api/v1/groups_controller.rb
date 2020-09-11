module Api
  class V1::GroupsController < V1::BaseController
    before_action :validate_record, except: [:create, :index]
    before_action :validate_status, only: [:status]

    def index
      groups = current_user.groups.includes(:users).filter_on(filter_params)
      render_success_response(
        { groups: array_serializer.new(groups, serializer: Api::V1::GroupSerializer) },
        '',  200, page_meta(groups, filter_params)
      )
    end

    def create
      group = Group.new(group_params)
      group.owner = current_user
      if group.save
        render_success_response( { group: group_data(group) }, 'Group is created successfully' )
      else
        render_unprocessable_entity(group.errors.full_messages.join(','))
      end
    rescue ActiveRecord::RecordNotFound
      invalid_user_response
    rescue
      invalid_images_response
    end

    def update
      @group.attributes = group_params
      if @group.save
        render_success_response( { group: group_data(@group) }, 'Group is updated successfully' )
      else
        render_unprocessable_entity(@group.errors.full_messages.join(','))
      end
    rescue ActiveRecord::RecordNotFound
      invalid_user_response
    rescue
      invalid_images_response
    end

    def show
      render_success_response( { group: group_data(@group) })
    end

    def destroy
      if @group.leave_group(current_user)
        data = { status: true, message: 'Group is left successfully.', data: nil}
        render json: data, status: default_status
      else
        render_unprocessable_entity(@group.errors.full_messages.join(','))
      end
    end

    def remove_avatar
      if @group.avatar.attached?
        @group.avatar.purge
        render_success_response( { group: group_data(@group) }, 'Group Avatar is removed.')
      else
        render_unprocessable_entity('Avatar is not found')
      end
    end

    def status
      @group.attributes = group_status_params
      if @group.save
        message = @group.active? ? 'Group is active now' : 'Group is hide now'
        render_success_response( { group: group_data(@group) }, message )
      else
        render_unprocessable_entity(@group.errors.full_messages.join(','))
      end
    end

    private

    def invalid_user_response
      render_unprocessable_entity('One of passed user is invalid')
    end

    def group_params
      params.require(:group).permit(
        :name, :description, :privacy, :university, :section, :president, :vice_president, :treasure, :social_director,
        :secretary, :email, :calendar_link, avatar: :data,
        groups_users_attributes: [:id, :user_id, :admin, :_destroy])
    end

    def group_status_params
      params.require(:group).permit(:status)
    end

    def group_user_params
      params.require(:group).permit(user_ids: [])
    end

    def filter_params
      params.permit(:page, :per)
    end

    def group_data(object)
      single_serializer.new(object, serializer: Api::V1::GroupSerializer, current_user: current_user)
    end

    def validate_record
      group_user = current_user.groups_users.find_by_group_id(params[:id])
      @group = group_user.try(:group)
      render_unprocessable_entity('Group is not found') and return if group_user.nil?
      render_unprocessable_entity('You are not authorized to manage this group') unless group_user.admin?
    end

    def invalid_images_response
      render_unprocessable_entity('Image is invalid. Please upload valid image')
    end

    def validate_status
      if group_status_params[:status].present? && !group_status_params[:status].in?(%w(active in_active))
        render_unprocessable_entity('Status value is not valid')
      end
    end

  end
end
