# frozen_string_literal: true

module BTCMarket
  module Models
    class Order
      attr_reader :btc, :price, :side

      def initialize(btc, price, side)
        @btc = btc
        @price = price
        @side = side
      end
    end
  end
end
