class YearsController < ApplicationController
  def show
    @year = Year.find_by!(number: params[:year])
    @participants = @year.participants.includes(user: :coalition).includes(:stars).order(score: :desc)
    if current_user
      @participant = @year.participants.includes(user: :coalition).find_by(user: current_user)
    end
    @today = @year.days.includes(stars: { participant: { user: :coalition } })
                       .where(open: true)
                       .order(number: :desc)
                       .first
  end
end
