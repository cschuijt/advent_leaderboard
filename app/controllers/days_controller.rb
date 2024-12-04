class DaysController < ApplicationController
  def show
    @day = Year.find_by!(number: params[:year])
               .days.includes(stars: { participant: { user: :coalition } })
               .find_by!(number: params[:day])
  end
end
