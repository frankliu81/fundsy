class CallbacksController < ApplicationController
  def twitter
    # env['omniauth.auth'] will be a Hash that will contain the user's uid and
    # other information such as their image profile and bio.
    user = User.find_or_create_with_twitter request.env['omniauth.auth']
    session[:user_id] = user.id
    #byebug
    redirect_to root_path, notice: "Thank you for signing in with Twitter"
  end
end
