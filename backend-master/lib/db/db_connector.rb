# frozen_string_literal: true

# This is a mock for a database connector
# that will be replaced with a SQL connected if given enought time to polish
# for the moment it's in-memory

module BTCMarket
  class DBConnector
    attr_reader :bids, :asks

    # starts with two empty sides
    def initialize
      @bids = {}
      @asks = {}
      @id = -1
    end

    # store the order if side is correctly set
    def create(order)
      add_order(order, @bids) if order.side == BUY
      add_order(order, @asks) if order.side == SELL
      @id
    end

    # checks if key exists in any of the side
    # then deletes it
    # return true if deletion is a success
    def delete(id)
      @bids[id] = nil if @bids.key?(id)
      @asks[id] = nil if @asks.key?(id)
      @bids.key?(id) || @asks.key?(id)
    end

    private

    def add_order(order, side)
      @id += 1
      side[@id] = [order.price, order.btc]
    end
  end
end
