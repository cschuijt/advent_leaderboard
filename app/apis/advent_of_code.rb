# This module contains all the tools to do with fetching and interpreting
# leaderboard data from Advent of Code.
module AdventOfCode
  # The Setup is intended to be run in advance and creates
  # the models required to run the year's leaderboard.
  class Setup
    def initialize(year)
      @year = year
    end

    def create_models(day_count = 12)
      ActiveRecord::Base.transaction do
        # If the year already exists, this will raise an error
        # and interrupt the transaction/job.
        new_year = Year.create!(number: @year)
        day_count.times do |i|
          Day.create!(year: new_year, number: i + 1)
        end
      end
    end
  end

  # The Parser class finds and updates a given leaderboard in the
  # database with data fetched from the API.
  class Parser
    def initialize(response)
      @response = response
      # If we cannot find a Year object for this response,
      # we should raise an error now.
      @year = Year.includes(participants: :user, days: :stars)
                  .find_by!(number: response['event'])
    end

    def import
      ActiveRecord::Base.transaction do
        @users = User.all

        @response['members'].each do |k, v|
          # Check if the user is known to us, eg. a user has listed
          # this AoC user ID as their own. If so, we can find or create
          # a participant in this year. If not, we move on to the next.
          user = @users.find { |u| u.aoc_user_id == k }
          if user && v['completion_day_level'].any?
            # We use this construction instead of find_or_create_by to
            # avoid N+1 queries here.
            participant = @year.participants.find { |p| p.user_id == user.id } ||
                          @year.participants.create!(user: user)
            participant.update!(score: v['local_score'])
            update_participant_stars(participant, v)
          end
        end
      end
    end

    private

    def update_participant_stars(participant, values)
      # Double iterator loop babyyyy
      # We go over each day the user has achieved stars for,
      # then we try to see if that star already exists in our
      # database for that user. If not, we create it now.
      values['completion_day_level'].each do |day_no, stars|
        day = @year.days.find { |d| d.number == day_no.to_i }
        raise ActiveRecord::RecordNotFound.new if day.nil?

        stars.each do |star_index, data|
          unless day.stars.find { |s|
            # Use participant_id here to avoid N+1 queries
            s.index == star_index.to_i && s.participant_id == participant.id
          }
            day.stars.create!(
              index: star_index,
              participant: participant,
              completed_at: Time.at(data['get_star_ts'].to_i)
            )
          end
        end
      end
    end
  end

  # The APIClient class is a thin wrapper around
  # HTTParty to fetch a given leaderboard.
  class APIClient
    include HTTParty
    base_uri 'adventofcode.com'

    def initialize(year, leaderboard_id, login_cookie)
      @options = {
        headers: { 'Cookie': string_from_login_cookie(login_cookie) }
      }

      @uri = "/#{year}/leaderboard/private/view/#{leaderboard_id}.json"
    end

    def leaderboard
      response = self.class.get(@uri, @options)

      if !response.ok?
        raise AdventOfCode::HTTPError.new(
          'Got an error fetching data from Advent of Code',
          response.response
        )
      # AoC does not really have a formal API, if
      # our request fails we just get an HTML response
      # instead. This condition is there to catch that.
      elsif response.headers['content-type'] != 'application/json'
        raise AdventOfCode::FormattingError.new(
          'Did not get a JSON response. Do we have permission to view this leaderboard?',
          response.response
        )
      else
        return JSON.parse(response.body)
      end
    end

    private

    def string_from_login_cookie(login_cookie)
      return "session=#{login_cookie}"
    end
  end

  # Errors

  class HTTPError < StandardError
    attr_reader :response

    def initialize(message='HTTP Error', response=nil)
      @response = response
      super(message)
    end
  end

  class FormattingError < StandardError
    attr_reader :response

    def initialize(message='Non-JSON response', response=nil)
      @response = response
      super(message)
    end
  end
end
