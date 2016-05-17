class Api::BaseController < ApplicationController
  before_action :authenticate_user
  protect_from_forgery with: :null_session

private

  def authenticate_user
    @user = User.find_by_api_key params[:api_key]
    # We can't redirect but we can send a different HTTP code
    head :forbidden unless @user
  end

end
