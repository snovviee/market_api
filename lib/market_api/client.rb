require_relative 'connection'

module MarketApi
  class Client
    attr_reader :api_key

    ENDPOINTS = {
      set_prices: { path: '/api/MassSetPrice', verb: :get },
      balance: { path: '/api/GetMoney', verb: :get },
      p2p: { path: '/api/v2/trade-request-give-p2p-all', verb: :get },
      best_offer: { path: '/api/BestSellOffer', verb: :get },
      remove_all: { path: '/api/RemoveAll', verb: :get },
      get_money: { path: '/api/GetMoney', verb: :get },
      pay_password: { path: '/api/v2/set-pay-password', verb: :get },
      list_items: { path: '/api/v2/get-list-items-info', verb: :get },
      add_to_sale: { path: '/api/v2/add-to-sale', verb: :get },
      stem_inventory: { path: '/api/v2/my-inventory', verb: :get },
      market_inventory: { path: '/api/v2/items', verb: :get },
      prices_usd: { path: '/api/v2/prices/USD.json', verb: :get }
    }

    def initialize(api_key:)
      @api_key = api_key
    end

    def connection
      @connection ||= Connection.create(api_key: api_key)
    end

    def balance
      endpoint = ENDPOINTS[__callee__]
      connection.send(endpoint[:verb], endpoint[:path])
    end

    def prices_usd
      endpoint = ENDPOINTS[__callee__]
      connection.send(endpoint[:verb], endpoint[:path])
    end

    def list_items(body)
      endpoint = ENDPOINTS[__callee__]
      connection.send(endpoint[:verb], endpoint[:path], body)
    end
  end
end
