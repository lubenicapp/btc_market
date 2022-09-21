# frozen_string_literal: true

module PaymiumMarket
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
        result = Hash.new
        orders.where(side: BUY).each { |order| result[order[:id]] = [order[:price], order[:amount]] }
        result
      end

      def asks
        result = Hash.new
        orders.where(side: SELL).each { |order| result[order[:id]] = [order[:price], order[:amount]] }
        result
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
