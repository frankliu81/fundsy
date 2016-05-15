module LoginHelper

  def login(user)
    # Note that this request method is only accessible in user/session controller method
    request.session[:user_id] = user.id
  end
  
end
