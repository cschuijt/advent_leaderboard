class UsersController < ApplicationController
  before_action :signed_in_user

  def edit
    @user = current_user
    render 'users/_edit'
  end

  def update
    @user = current_user

    if @user.update(user_params)
      render 'users/_success'
    else
      render 'users/_edit'
    end
  end

  def destroy
    @user = current_user

    log_out # Ensure the user is not logged in anymore!
    @user.destroy

    flash[:notice] = "Successfully removed your account from the systems."
    redirect_to root_url
  end

  private

  def user_params
    params.require(:user).permit(:aoc_user_id)
  end

  def signed_in_user
    redirect_to root_url unless logged_in?
  end
end
