module APIClient
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
