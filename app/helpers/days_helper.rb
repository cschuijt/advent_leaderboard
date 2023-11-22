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

  def top_speeds(day)
    stars = day.stars.joins(:participant).order(index: :desc, completed_at: :asc).limit(6)

    # It is possible that our array includes two stars for the same
    # participant, so we grab the maximum required number and
    # filter out duplicate values.
    return stars.map(&:participant).uniq.first(3)
  end

  def rank_for_participant(day, participant)
    top_star = day.stars.where(participant: participant).order(index: :desc).first

    if !top_star
      "Incomplete"
    elsif top_star.index == 2
      "Gold"
    else
      "Silver"
    end
  end

  def time_for_participant(day, participant)
    top_star = day.stars.where(participant: participant).order(index: :desc).first

    if !top_star
      nil
    else
      top_star.completed_at
    end
  end
end
