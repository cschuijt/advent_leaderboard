module UsersHelper
  def join_code
    ENV.fetch("AOC_LEADERBOARD_JOIN_TOKEN") { "[No token found, please update env vars]" }
  end
end
