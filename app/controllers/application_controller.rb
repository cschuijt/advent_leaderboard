class ApplicationController < ActionController::Base
  include SessionsHelper

  private

  def logged_in_user
    return if logged_in?

    flash[:error] = "You need to log in to access this page!"
    redirect_to root_url
  end
end
