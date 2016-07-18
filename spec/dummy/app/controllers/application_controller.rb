class ApplicationController < ActionController::Base
  include Referrer::ControllerAdditions

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user; User.first; end
end
