# frozen_string_literal: true

module PaymiumMarket
  module Market
    class BTCMarket < PaymiumMarket::Market::Base
      BASE = 'BTC'
      QUOTE = 'EUR'

      # a simplified order representation for easy manipulation
      class SimpleOrder
        extend Dry::Initializer

        param :id
        param :price
        param :amount
      end

      # sets the database connector
      def initialize(db_connector = PaymiumMarket::Database::MysqlConnector.new)
        @db = db_connector
      end

      def submit(order)
        @db.create(order)
      end

      def market_price
        ((BigDecimal(max_bid.price) + BigDecimal(min_ask.price)) / 2.0).to_f
      rescue NoMethodError
        return 0
      end

      def market_depth
        {
          'bids' => bids.values.sort_by { |order| - BigDecimal(order[0]) },
          'base' => BASE,
          'quote' => QUOTE,
          'asks' => asks.values.sort_by { |order| - BigDecimal(order[0]) }
        }
      end

      def cancel_order(id)
        @db.delete(id)
      end

      # simplified matching engine
      def match
        bid = max_bid
        ask = min_ask
        if bid.price == ask.price
          begin
            # change order status
            # change users balance
          rescue Error
            #TODO
          end
          return 1 + match
        end
        0
      end

      private

      def bids
        @db.bids
      end

      def asks
        @db.asks
      end

      def max_bid
        candidate = @db.bids.max_by {|k, v| BigDecimal(v[0])}
        return SimpleOrder.new(-1, 0, 0) if candidate.nil?

        SimpleOrder.new candidate[0], candidate[1][0], candidate[1][1]
      end

      def min_ask
        candidate = @db.asks.max_by {|k, v| BigDecimal(v[0])}
        return SimpleOrder.new(-1, 0, 0) if candidate.nil?

        SimpleOrder.new candidate[0], candidate[1][0], candidate[1][1]
      end
    end
  end
end
