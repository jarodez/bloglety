module SessionsHelper

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def current_user?(user)
    @current_user == user
  end

  def sign_in(user)
    cookies.permanent[:remember_token] = {value: user.remember_token, expires: 20.years.from_now.utc}
    session[:user_id] = user.id
  end

  def sign_out
     session[:user_id] = nil
  end

  def signed?
    !current_user.nil?
  end

end