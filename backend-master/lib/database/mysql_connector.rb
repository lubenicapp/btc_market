# frozen_string_literal: true

module PaymiumMarket
  module Database
    class MysqlConnector < PaymiumMarket::Database::Base
      DATABASE = Sequel.connect(
        adapter: 'mysql2',
        user: ENV['DB_USERNAME'],
        host: ENV['DB_HOST'],
        database: ENV['DATABASE'],
        password: ENV['DB_PASSWORD']
      )

      def initialize(base = 'BTC/EUR')
        @market = base
      end
      def create(order)
        orders.insert(
          amount: order.amount,
          price: order.price,
          side: order.side,
          state: CREATED,
          user_id: order.user_id,
          market: @market
        )
      end

      def delete(id)
        selection = orders.where(id: id)
        return false if selection.empty?

        selection.delete
        true
      end

      def bids
        result = {}
        orders.where(side: BUY, state: CREATED, market: @market).each { |order| result[order[:id]] = [order[:price], order[:amount]] }
        result
      end

      def asks
        result = {}
        orders.where(side: SELL, state: CREATED, market: @market).each { |order| result[order[:id]] = [order[:price], order[:amount]] }
        result
      end

      def find_user_for_order(order_id)
        user_id = orders.where(id: order_id).first[:user_id]
        users.where(id: user_id).first
      end

      def find_order(order_id)
        orders.where(id: order_id).first
      end

      def find_user(user_id)
        users.where(id: user_id).first
      end

      # used to increase or decrease the token balance
      # by amount
      def change_user_balance(user_id, token, amount)
        user = find_user(user_id)
        user_balance = BigDecimal(user[token.to_sym])
        new_balance = user_balance + amount
        users.where(id: user_id).update token => new_balance.to_s
      end

      def fill_order(order)
        orders.where(id: order[:id]).update(state: FILLED)
      end

      private

      def orders
        DATABASE[:orders]
      end

      def users
        DATABASE[:users]
      end
    end
  end
end
