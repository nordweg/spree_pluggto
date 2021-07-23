module SpreePluggto::Api
  class Request
    attr_reader :access_token

    def initialize
      @access_token = SpreePluggto::Api::Oauth.new.get_token
    end

    def get(path, body = {})
      response = request.get(path, body)
      response.success? ? response.body : raise_error(response)
    end

    def put(path, body = {})
      response = request.put(path, body)
      response.success? ? response.body : raise_error(response)
    end

    def post(path, body = {})
      response = request.post(path, body)
      response.success? ? response.body : raise_error(response)
    end

    private

    def request
      @request ||= Faraday.new(url:"https://api.plugg.to") do |conn|
        conn.request  :oauth2, access_token, token_type: 'bearer'
        conn.request  :json
        conn.response :json
        conn.adapter  Faraday.default_adapter
      end
    end

    def raise_error(response)
      message = {
        status: response.status,
        reason: response.reason_phrase,
        body:   response.body,
      }
      fail Exception.new(message)
    end
  end
end
