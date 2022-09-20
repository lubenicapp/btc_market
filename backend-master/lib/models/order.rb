# frozen_string_literal: true

module PaymiumMarket
  module Models
    class Order
      attr_reader :amount, :price, :side

      def initialize(amount:, price:, side:)
        @amount = amount
        @price = price
        @side = side
      end

      def buy?
        @side == BUY
      end

      def sell?
        @side == SELL
      end
    end
  end
end
