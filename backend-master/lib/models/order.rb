# frozen_string_literal: true

module PaymiumMarket
  module Models
    class Order
      attr_reader :amount, :price, :side, :user_id

      def initialize(amount:, price:, side:, user_id:)
        @amount = amount
        @price = price
        @side = side
        @user_id = user_id
        validate
      end

      def buy?
        @side == BUY
      end

      def sell?
        @side == SELL
      end

      private

      def validate
        #TODO
      end
    end
  end
end
