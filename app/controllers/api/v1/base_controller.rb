class Api::V1::BaseController < ActionController::API
  include ApplicationMethods
  include Pagination
  before_action :doorkeeper_authorize!
  before_action :check_per_page

  def check_per_page
    Kaminari.configure do |config|
      config.default_per_page = 5
    end
  end

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
