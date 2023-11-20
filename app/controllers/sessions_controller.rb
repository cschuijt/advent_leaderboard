class SessionsController < ApplicationController
  before_action :logged_in_user,    only: :destroy
  before_action :already_logged_in, only: :create

  # Creates a session cookie, adds the user to the database if they do not
  # exist yet, then redirects them to the root url.
  def create
    auth = request.env['omniauth.auth']

    unless auth.extra.raw_info.campus.any? { |campus| campus.id == 14 } # Codam's ID
      flash[:error] = 'You are not associated with Codam, so you cannot log in here!'
      redirect_to root_url
    end

    user = User.find_or_create_by(username: auth.info.login)
    user.full_name = auth.extra.raw_info.usual_full_name
    user.photo_url = auth.extra.raw_info.image.versions.medium

    user.save!

    log_in(user)
    flash[:notice] = 'Successfully logged in.'
    redirect_to root_url
  end

  # Destroys the session cookie and logs the user out.
  def destroy
    log_out

    flash[:notice] = 'Successfully logged out.'
    redirect_to root_url
  end

  # Endpoint reached when something goes wrong during OAuth
  def failure
    flash[:error] = 'Login was unsuccessful, please try again!'
    redirect_to root_url
  end

  private

  def already_logged_in
    return unless logged_in?

    flash[:error] = 'You are already logged in!'
    redirect_to root_url
  end
end
