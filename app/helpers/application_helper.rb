module ApplicationHelper
  def page_title(title = "")
    if title.empty?
      'Codam AoC Leaderboard'
    else
      "#{title} | Codam AoC Leaderboard"
    end
  end
end
