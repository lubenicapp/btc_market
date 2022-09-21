# frozen_string_literal: true

module PaymiumMarket
  module Services
    # This module solves the matching order.
    # The class including this OrderSolver must have
    # - a database connector @db inheriting the PaymiumMarket::DataBase::Base
    # - a fee percentage @fee
    # - a @base matching the user column name
    module OrderSolver
      # a simplified order representation for easy manipulation
      class SimpleOrder
        extend Dry::Initializer

        param :id
        param :price
        param :amount

        def valid?
          id > 0
        end
      end

      # this method resolves order with two 'SimplifiedOrder'
      def resolve(simple_buy, simple_sell)
        buy_order = @db.find_order(simple_buy.id)
        sell_order = @db.find_order(simple_sell.id)

        buyer = @db.find_user_for_order(simple_buy.id)
        seller = @db.find_user_for_order(simple_sell.id)

        total_fees = resolve_seller(seller, sell_order)
        total_fees += resolve_buyer(buyer, buy_order)

        @db.change_user_balance(@fee_user_id, 'eur', total_fees)

        @db.fill_order(buy_order)
        @db.fill_order(sell_order)

        puts "total_fees #{total_fees}"
      end

      private

      def resolve_seller(seller, order)
        token_amount = BigDecimal(order[:amount])
        eur_raw = token_amount * BigDecimal(order[:price])
        eur_net = eur_raw * (1 - @fee)

        @db.change_user_balance(seller[:id], @base, -token_amount)
        @db.change_user_balance(seller[:id], 'eur', eur_net)

        eur_raw * @fee
      end

      def resolve_buyer(buyer, order)
        token_amount = BigDecimal(order[:amount])
        eur_raw = token_amount * BigDecimal(order[:price])
        eur_net = eur_raw * (1 - @fee)

        @db.change_user_balance(buyer[:id], @base,  token_amount)
        @db.change_user_balance(buyer[:id], 'eur', -eur_net)

        eur_raw * @fee
      end
    end
  end
end
