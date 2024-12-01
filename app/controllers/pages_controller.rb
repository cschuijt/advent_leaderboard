class PagesController < ApplicationController
  def home
    @year = Year.order(number: :desc).first
    if @year.nil?
      render 'pages/home'
      return
    end
    @today = @year.days.where(open: true).order(number: :desc).first
    @participants = @year.participants.order(score: :desc).joins(:user).includes(:stars)
    if current_user
      @participant = @year.participants.find_by(user: current_user)
    end
    render 'years/show'
  end
end
