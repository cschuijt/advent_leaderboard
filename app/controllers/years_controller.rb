class YearsController < ApplicationController
  def index
    @years = Year.all
  end

  def show
    @year = Year.find_by!(number: params[:year])
    @today = @year.days.where(open: true).order(number: :desc).first
  end
end
