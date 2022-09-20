# frozen_string_literal: true

module PaymiumMarket
  module Market
    class Base
      def submit(_order)
        raise NoMethodError
      end

      def market_price
        raise NoMethodError
      end

      def market_depth
        raise NoMethodError
      end

      def cancel_order(_id)
        raise NoMethodError
      end
    end
  end
end
