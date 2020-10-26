class ApplicationController < ActionController::Base
  serialization_scope :current_user
end
