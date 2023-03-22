require 'faraday'

module MarketApi
  class AuthMiddleware < ::Faraday::Middleware
    attr_reader :api_key

    def initialize(app, api_key)
      super(app)

      @api_key = api_key
    end

    def on_request(env)
      env.url.query ? env.url.query += "&key=#{api_key}" : env.url.query = "&key=#{api_key}"
    end
  end
end