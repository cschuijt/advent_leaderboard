class UsersController < ApplicationController
  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(user_params)
      render root_url
    else
      render 'edit'
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
end
