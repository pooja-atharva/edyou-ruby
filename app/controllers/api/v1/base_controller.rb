class Api::V1::BaseController < ActionController::API
  include ApplicationMethods
  include Pagination
  before_action :doorkeeper_authorize!

  private
  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def current_user
    current_resource_owner
  end

  def default_status
    @status ||= 200
  end
end
