module YearsHelper
  def year_bg_array(year)
    array = []
    year.days.count.times do |i|
      array << nil
    end

    year.days.includes(:stars).where(stars: { participant_id: @participant&.id }).order(number: :asc).each do |day|
      array[day.number - 1] = bg_class_for_star_count(day.stars.length)
    end

    return array
  end

  def bg_class_for_star_count(star)
    if logged_in?
      arr = [nil, 'bg-silver', 'bg-gold']
      return arr[star]
    else
      return nil
    end
  end

  def count_completed_days(year)
    return year.stars.includes(:day).map(&:day).uniq.length
  end
end
