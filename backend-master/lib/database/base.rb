# frozen_string_literal: true

module PaymiumMarket
  module Database
    class Base

      def create(order)
        raise NoMethodError
      end

      def delete(id)
        raise NoMethodError
      end
    end
  end
end

