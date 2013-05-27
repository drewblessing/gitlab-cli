module GitlabCli
  class ResponseCodeException < RuntimeError
    attr :response_code
    def initialize(response_code)
      @response_code = response_code
    end
  end
end

