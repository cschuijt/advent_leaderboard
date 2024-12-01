module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
    Sentry.set_user({
      id: user.id,
      username: user.username
    })
  end

  def current_user
    return unless session[:user_id]

    @current_user ||= User.find_by(id: session[:user_id])
    Sentry.set_user({
      id: @current_user.id,
      username: @current_user.username
    })

    return @current_user
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
    Sentry.set_user({})
  end

  def current_user?(user)
    user == current_user
  end
end
