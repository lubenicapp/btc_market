# frozen_string_literal: true

module PaymiumMarket
  module Database
    class Base
      # save the order and return its id
      def create(_order)
        raise NoMethodError
      end

      # delete order with provided id
      # returns true if performed, otherwise false
      def delete(_id)
        raise NoMethodError
      end

      # return all 'buy' orders
      # as a hash : { id => [price, amount] }
      def bids
        raise NoMethodError
      end

      # return all 'sell' orders

      # as a hash : { id => [price, amount] }
      def asks
        raise NoMethodError
      end
    end
  end
end
