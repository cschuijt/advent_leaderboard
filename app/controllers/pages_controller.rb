class PagesController < ApplicationController
  def home
    @year = Year.order(number: :desc).first
    if @year.nil?
      render 'pages/home'
      return
    end
    @today = @year.days.where(open: true).order(number: :desc).first
    render 'years/show'
  end
end
