require_relative 'connection'

module MarketApi
  class Client
    attr_reader :api_key

    ENDPOINTS = {
      balance: { path: '/api/GetMoney', verb: :get },
      p2p: { path: '/api/v2/trade-request-give-p2p-all', verb: :get },
      remove_all: { path: '/api/RemoveAll', verb: :get },
      get_money: { path: '/api/GetMoney', verb: :get },
      pay_password: { path: '/api/v2/set-pay-password', verb: :get },
      list_items: { path: '/api/v2/get-list-items-info', verb: :get },
      add_to_sale: { path: '/api/v2/add-to-sale', verb: :get },
      steam_inventory: { path: '/api/v2/my-inventory', verb: :get },
      market_inventory: { path: '/api/v2/items', verb: :get },
      prices_usd: { path: '/api/v2/prices/USD.json', verb: :get },
      ping: { path: '/api/PingPong/direct', verb: :get },
      money_send: { path: '/api/v2/money-send', verb: :get },
      trade_check: { path: '/api/Test', verb: :get },
      update_inventory: { path: '/api/UpdateInventory', verb: :get },
      bind_steam_api_key: { path: '/api/v2/set-steam-api-key', verb: :get }
    }

    def initialize(api_key:)
      @api_key = api_key
      ENDPOINTS.each do |_method, declaration|
        block = ->(body){ connection.send(declaration[:verb], declaration[:path], body) }

        self.class.define_method(_method) { |body={}| block.call(body) }
      end
    end

    def connection
      @connection ||= Connection.create(api_key: api_key)
    end

    def best_offer(class_id, instance_id)
      connection.get("/api/BestSellOffer/#{class_id}_#{instance_id}")
    end

    def set_prices(class_id, instance_id, price)
      connection.get("/api/MassSetPrice/#{class_id}_#{instance_id}/#{price}")
    end
  end
end
