class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # you usually don't do redirect in view file, so no need
  # to make it a helper method
  def authenticate_user!
    redirect_to new_user_path unless user_signed_in?
  end

  # you may need to make this available later as helper method
  # for hte view
  def user_signed_in?
    session[:user_id].present?
  end
  helper_method :user_signed_in?

  def current_user
    @current_user ||= User.find session[:user_id] if user_signed_in?
  end
  helper_method :current_user
end
