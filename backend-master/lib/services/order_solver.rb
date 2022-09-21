# frozen_string_literal: true

module PaymiumMarket
  module Services
    # This module solves the matching order.
    # The class including this OrderSolver must have
    # - a database connector @db inheriting the PaymiumMarket::DataBase::Base
    # - a fee percentage @fee
    module OrderSolver
      def resolve(simple_buy, simple_sell)

      end
    end
  end
end
