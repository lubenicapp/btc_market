# frozen_string_literal: true

module BTCMarket
  class Market
    # sets the database connector
    def initialize(db_connector = DBConnector.new)
      @db = db_connector
    end

    # creates a new order in the database
    def submit(order)
      @db.create(order)
    end

    # gives the market price
    def market_price
      max_bid + min_ask / 2
    end

    # returns a hash with the market status
    def market_depth
      {
        'bids' => bids,
        'base' => BASE,
        'quite' => QUOTE,
        'asks' => asks
      }
    end

    # removes an order from the database
    def cancel_order(id)
      @db.delete(id)
    end

    private

    def bids
      @db.bids.reject { |_k, v| v.nil? }.values.sort_by { |order| order[0] }
    end

    def asks
      @db.asks.reject { |_k, v| v.nil? }.values.sort_by { |order| order[0] }
    end

    def max_bid
      max_order = @db.bids.values.max_by { |order| order[0] }
      return 0 if max_order.nil? || max_order[0].nil?

      max_order[0]
    end

    def min_ask
      min_order = @db.asks.values.max_by { |order| order[0] }
      return 0 if min_order.nil? || min_order[0].nil?

      min_order[0]
    end
  end
end
