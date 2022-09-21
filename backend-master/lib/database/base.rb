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

      # returns a user
      def find_user_for_order(order_id)
        raise NoMethodError
      end

      # returns an order
      def find_order(order_id)
        raise NoMethodError
      end

      # returns a user
      def find_user(user_id)
        raise NoMethodError
      end

      # used to increase or decrease the token balance
      # by amount
      def change_user_balance(user_id, token, amount)
        raise NoMethodError
      end

      # change order status to FILLED
      def fill_order(order)
        raise NoMethodError
      end
    end
  end
end
