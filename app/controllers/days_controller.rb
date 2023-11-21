class DaysController < ApplicationController
  def show
    @day = Year.find_by!(number: params[:year])
               .days.find_by!(number: params[:day])
  end
end
