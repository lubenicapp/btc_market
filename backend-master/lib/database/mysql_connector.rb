# frozen_string_literal: true

module Paymium
  module Database
    class MysqlConnector < PaymiumMarket::Database::Base

      DATABASE = Sequel.connect(
        :adapter => 'mysql2',
        :user => ENV['DB_USERNAME'],
        :host => ENV['DB_HOST'],
        :database => ENV['DATABASE'] ,
        :password=>ENV['DB_PASSWORD'])

      def create(order)
        orders.insert(
          amount: order.amount,
          price: order.price,
          side: order.side,
          state: CREATED,
          user_id: order.user_id)
      end

      def delete(id)
        selection = orders.where(id: id)
        return false if selection.empty?

        selection.delete
        true
      end

      def bids
        orders.where(side: BUY).map { |order| { order[:id] => [order[:price], order[:amount]] }}
      end

      def asks
        orders.where(side: SELL).map { |order| { order[:id] => [order[:price], order[:amount]] }}
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
