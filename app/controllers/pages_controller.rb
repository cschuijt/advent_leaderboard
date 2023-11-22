class PagesController < ApplicationController
  def home
    @year = Year.last # Assuming the most recent year was created last...
    if @year.nil?
      render 'pages/home'
      return
    end
    @today = @year.days.where(open: true).order(number: :desc).first
    render 'years/show'
  end
end
