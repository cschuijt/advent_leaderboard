module AdventOfCode
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
      elsif response.headers['content-type'] != 'application/json'
        raise AdventOfCode::FormattingError.new(
          'Did not get a JSON response. Do we have permission to view this leaderboard?',
          response.response
        )
      else
        return response
      end
    end

    private

    def string_from_login_cookie(login_cookie)
      return "session=#{login_cookie}"
    end
  end

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
