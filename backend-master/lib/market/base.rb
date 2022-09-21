# frozen_string_literal: true

module PaymiumMarket
  module Market
    class Base

      # persist an order
      def submit(_order)
        raise NoMethodError
      end

      # gives the market price according to a calculation rule
      def market_price
        raise NoMethodError
      end

      # display the market state
      # { 'bids' => [[price, amount], ...], base:, quote:, asks => [[price, amount], ...]}
      def market_depth
        raise NoMethodError
      end

      # delete an order
      def cancel_order(_id)
        raise NoMethodError
      end

      # resolve matching orders
      def match
        raise NoMethodError
      end
    end
  end
end
