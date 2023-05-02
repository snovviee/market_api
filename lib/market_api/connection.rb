require_relative 'auth_middleware'

module MarketApi
  class Connection
    private_class_method :new

    Faraday::NestedParamsEncoder.sort_params = false
    Faraday::Request.register_middleware market_auth: -> { AuthMiddleware }

    HOST = 'https://market.csgo.com'

    def self.create(api_key:)
      Faraday.new(
        url: HOST,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }
      ) do |f|
        f.request :url_encoded
        f.request :market_auth, api_key
        f.response :logger, ::Logger.new(STDOUT), bodies: true, headers: false
        f.response :json, parser_options: { symbolize_names: true }
      end
    end
  end
end
