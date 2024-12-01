class PagesController < ApplicationController
  def home
    @year = Year.order(number: :desc).first
    if @year.nil?
      render 'pages/home'
    else
      redirect_to year_url(@year.number)
    end
  end
end
