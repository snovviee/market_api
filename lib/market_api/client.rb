require_relative 'connection'
require 'net/http'

module MarketApi
  class Client
    attr_reader :api_key

    ENDPOINTS = {
      balance: { path: '/api/GetMoney', verb: :get },
      balance_v2: { path: '/api/v2/get-money', verb: :get },
      p2p: { path: '/api/v2/trade-request-give-p2p-all', verb: :get },
      remove_all: { path: '/api/RemoveAll', verb: :get },
      remove_all_v2: { path: '/api/v2/remove-all-from-sale', verb: :get },
      get_money: { path: '/api/GetMoney', verb: :get },
      pay_password: { path: '/api/v2/set-pay-password', verb: :get },
      list_items: { path: '/api/v2/get-list-items-info', verb: :get },
      add_to_sale: { path: '/api/v2/add-to-sale', verb: :get },
      steam_inventory: { path: '/api/v2/my-inventory', verb: :get },
      market_inventory: { path: '/api/v2/items', verb: :get },
      prices_usd: { path: '/api/v2/prices/USD.json', verb: :get },
      ping: { path: '/api/PingPong/direct', verb: :get },
      trade_check: { path: '/api/Test', verb: :get },
      trade_check_v2: { path: '/api/v2/test', verb: :get },
      update_inventory: { path: '/api/UpdateInventory', verb: :get },
      update_inventory_v2: { path: '/api/v2/update-inventory', verb: :get },
      bind_steam_api_key: { path: '/api/v2/set-steam-api-key', verb: :get },
      current_730: { path: 'itemdb/current_730.json', verb: :get },
      prices_rub_c_i: { path: '/api/v2/prices/class_instance/RUB.json', verb: :get },
      trades: { path: '/api/v2/trades', verb: :get },
      delete_orders: { path: '/api/DeleteOrders', verb: :get },
      ws_auth: { path: '/api/v2/get-ws-auth', verb: :get },
      get_orders: { path: '/api/GetOrders', verb: :get },
      ping_v2: { path: '/api/v2/ping', verb: :get }
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

    def money_send(amount:, whom:, pay_password:)
      connection.get("/api/v2/money-send/#{amount}/#{whom}?pay_pass=#{pay_password}")
    end

    def change_currency_to_usd(new_currency: 'USD')
      connection.get("/api/v2/change-currency/#{new_currency}")
    end

    def best_offer(class_id, instance_id)
      connection.get("/api/BestSellOffer/#{class_id}_#{instance_id}")
    end

    def search_list_items_by_hash_name_all(list_item_name)
      url = "https://market.csgo.com/api/v2/search-list-items-by-hash-name-all?key=#{api_key}"
      uri = URI(url)
      da = Net::HTTP.post_form(uri, 'list_hash_name[]=' => list_item_name)
    end

    def set_prices(class_id, instance_id, price)
      connection.get("/api/MassSetPrice/#{class_id}_#{instance_id}/#{price}")
    end

    def set_prices_v2(item_id, price, cur = 'USD')
      connection.get("/api/v2/set-price?/&item_id=#{item_id}&price=#{price}&cur=#{cur}")
    end

    def itemdb(csv_path)
      connection.get("/itemdb/#{csv_path}")
    end

    def process_order(class_id, instance_id, price)
      connection.get("/api/ProcessOrder/#{class_id}/#{instance_id}/#{price}")
    end

    def best_buy_order(class_id, instance_id)
      connection.get("/api/BestBuyOffer/#{class_id}_#{instance_id}")
    end

    def checkin_history(page_number)
      connection.get("/api/v2/checkin-history?/&page=#{page_number}")
    end
    
    def mass_info(list, searching_key: nil)
      url_key = searching_key || api_key
      url = "https://market.csgo.com/api/MassInfo/2/1/1/2?key=#{url_key}"
      uri = URI(url)
      Net::HTTP.post_form(uri, 'list' => list)
    end
  end
end
