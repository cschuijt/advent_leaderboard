module YearsHelper
  def bg_class_for_day(day)
    if logged_in?
      participant = day.year.participants.find_by(user: current_user)
      star = day.stars.where(participant: participant).order(index: :desc).first

      if !star
        return nil
      elsif star.index == 2
        return 'bg-gold'
      else
        return 'bg-silver'
      end
    else
      return nil
    end
  end
end
