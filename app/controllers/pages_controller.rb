class PagesController < ApplicationController
  def home
    @year = Year.last # Assuming the most recent year was created last...
    @today = @year.days.where(open: true).order(number: :desc).first
    render 'years/show'
  end
end
