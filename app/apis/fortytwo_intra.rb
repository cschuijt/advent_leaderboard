# This module deals with the endpoints for manually setting up profiles
# when their owners cannot log in with their 42 account.
module FortytwoIntra
  # Since the client will never change, we can instantiate it for the
  # entire module and avoid doing double work.
  def fortytwo_api_client
    @api_client ||= APIClient.new(ENV['FORTYTWO_KEY'], ENV['FORTYTWO_SECRET'])
  end

  class APIClient
    BASE_URL = 'https://api.intra.42.fr/v2'

    def initialize(uid, secret)
      @uid    = uid
      @secret = secret
    end

    # Returns a Ruby hash of the response from the endpoint, or raises
    # OAuth2::Error when a non-200 code is returned.
    def get(path)
      token.get(path).parsed
    end


    private

    def client
      @client ||= OAuth2::Client.new(@uid, @secret, site: BASE_URL)
    end

    # In case the token has expired, we need to request a new one.
    # A refresh URL is not available for this flow, so we just go
    # again with our API credentials through the client.
    def token
      if @token.nil? || @token.expired?
        @token = client.client_credentials.get_token
      end

      @token
    end
  end
end
