class UsersController < ApplicationController
  before_action :signed_in_user
  before_action :current_user_is_admin, only: [:new, :create]

  def new
    @user = User.new
    render 'users/_new', layout: 'no_turbo_frame'
  end

  def create
    @user = User.from_42_api(params[:user][:username])
    @user.aoc_user_id = params[:user][:aoc_user_id]

    if @user.save
      render 'users/_success'
    else
      render 'users/_new'
    end
  end

  def edit
    @user = current_user
    render 'users/_edit', layout: 'no_turbo_frame'
  end

  def update
    @user = current_user

    if @user.update(user_params)
      # To avoid complications with data, we destroy the
      # user's old participation if their id has changed and if
      # we can find one in the current year. The next scoreboard
      # sync will repopulate the leaderboard with their new data.
      if @user.aoc_user_id_previously_changed? && @user.aoc_user_id_previously_was &&
          @user.participations.find_by(year: Year.find_by(number: Time.now.year))
        @user.participations.find_by(year: Year.find_by(number: Time.now.year)).destroy
        flash.now[:warning] = "Your old data for #{Time.now.year} has been removed. Your new data will be backfilled at the next scoreboard update."
      end
      render 'users/_success'
    else
      render 'users/_edit'
    end
  end

  def destroy
    @user = current_user

    log_out # Ensure the user is not logged in anymore!
    @user.destroy

    flash[:notice] = 'Successfully removed your account from the systems.'
    redirect_to root_url
  end

  private

  def user_params
    params.require(:user).permit(:aoc_user_id, :coalition_id)
  end

  def signed_in_user
    redirect_to root_url unless logged_in?
  end

  def current_user_is_admin
    unless current_user.admin?
      flash[:danger] = 'You must be an admin to perform this action!'
      redirect_to root_url
    end
  end
end
