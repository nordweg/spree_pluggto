module SpreePluggto::Api
  class Oauth
    attr_accessor :settings

    def initialize
      @settings = PluggtoSettings.first_or_create
      refresh_token! unless valid_token?
    end

    def get_token
      settings.access_token
    end

    def valid_token?
      settings.token_expires_at.present? && settings.token_expires_at > (DateTime.now + 5.minutes)
    end

    def refresh_token!
      grant_type = settings.refresh_token.present? ? "refresh_token" : "password"
      body = {
        client_id: settings.client_id,
        client_secret: settings.client_secret,
        username: settings.username,
        password: settings.password,
        refresh_token: settings.refresh_token,
        grant_type: grant_type
      }
      response = oauth_request.post("/oauth/token", body)
      settings.update(
        access_token: response.body['access_token'],
        refresh_token: response.body['refresh_token'],
        token_expires_at: response.body['expires_in'].to_i.seconds.from_now
      ) if response.success?
      @settings = settings
    end

    private

    # Different request for OAuth since it expects form-encoded data instead of a json
    def oauth_request
      @oauth_request ||= Faraday.new(url:"https://api.plugg.to") do |builder|
        builder.request  :url_encoded             # form-encode params
        builder.response :json
        builder.adapter  Faraday.default_adapter
      end
    end
  end
end
