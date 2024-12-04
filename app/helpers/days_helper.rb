module DaysHelper
  # The  users that have not yet completed this
  # puzzle are the ones that have not yet gotten
  # the silver star.
  def count_incomplete(day)
    num_participants = day.year.participants.count
    num_silver = day.stars.where(index: 1).count

    return num_participants - num_silver
  end

  # The user count that is currently on silver is the
  # silver count minus the gold count.
  def count_silver(day)
    num_silver = day.stars.where(index: 1).count
    num_gold = day.stars.where(index: 2).count

    return num_silver - num_gold
  end

  # For the gold count, we can just count the gold stars
  # for this day.
  def count_gold(day)
    num_gold = day.stars.where(index: 2).count

    return num_gold
  end

  # For when we need the absolute total of silver stars,
  # rather than the participant count who only have this star.
  def count_silver_stars(day)
    return day.stars.where(index: 1).count
  end

  def top_speeds(day, index = 2, n = 3)
    stars = day.stars.includes(participant: { user: :coalition }).where(index: index)
                     .order(completed_at: :asc).limit(n)

    return stars
  end

  def rank_for_participant(day, participant)
    top_star = day.stars.where(participant: participant).order(index: :desc).first

    if !top_star
      "Incomplete"
    elsif top_star.index == 2
      "Gold + Silver"
    else
      "Silver"
    end
  end

  def time_taken(day, star)
    if star.completed_at > day.end_time
      return ">24 hrs"
    else
      difference = (star.completed_at.utc - day.start_time).abs
      Time.at(difference).to_time_taken
    end
  end
end
