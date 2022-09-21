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

      def create(order)
        orders.insert(
          amount: order.amount,
          price: order.price,
          side: order.side,
          state: CREATED,
          user_id: order.user_id
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
        orders.where(side: BUY, state: CREATED).each { |order| result[order[:id]] = [order[:price], order[:amount]] }
        result
      end

      def asks
        result = {}
        orders.where(side: SELL, state: CREATED).each { |order| result[order[:id]] = [order[:price], order[:amount]] }
        result
      end

      def find_user(order_id)
        user_id = orders.where(id: order_id).first[:user_id]
        users.where(id: user_id).first
      end

      private

      def orders
        @orders ||= DATABASE[:orders]
      end

      def users
        @users ||= DATABASE[:users]
      end
    end
  end
end
