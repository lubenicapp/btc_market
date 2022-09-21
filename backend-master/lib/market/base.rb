# frozen_string_literal: true

module PaymiumMarket
  module Market
    class Base
      include PaymiumMarket::Services::OrderSolver

      # persist an order
      def submit(order)
        @db.create(order)
      end

      def market_price
        ((BigDecimal(max_bid.price) + BigDecimal(min_ask.price)) / 2.0).to_f
      rescue NoMethodError
        0
      end

      def market_depth
        {
          'bids' => bids.values.sort_by { |order| - BigDecimal(order[0]) },
          'base' => @base.upcase,
          'quote' => @quote.upcase,
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
        if bid.price == ask.price && bid.valid? && ask.valid?
          begin
            resolve(max_bid, min_ask)
          rescue StandardError => e
            puts e
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
        candidate = bids.max_by { |_k, v| BigDecimal(v[0]) }
        return PaymiumMarket::Services::OrderSolver::SimpleOrder.new(-1, 0, 0) if candidate.nil?

        PaymiumMarket::Services::OrderSolver::SimpleOrder.new candidate[0], candidate[1][0], candidate[1][1]
      end

      def min_ask
        candidate = asks.max_by { |_k, v| BigDecimal(v[0]) }
        return PaymiumMarket::Services::OrderSolver::SimpleOrder.new(-1, 0, 0) if candidate.nil?

        PaymiumMarket::Services::OrderSolver::SimpleOrder.new candidate[0], candidate[1][0], candidate[1][1]
      end
    end
  end
end
