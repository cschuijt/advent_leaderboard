class YearsController < ApplicationController
  def show
    @year = Year.find_by!(number: params[:year])
    @participants = @year.participants.order(score: :desc).joins(:user).includes([:stars, :user])
    if current_user
      @participant = @year.participants.find_by(user: current_user)
    end
    @today = @year.days.where(open: true).order(number: :desc).first
  end
end
