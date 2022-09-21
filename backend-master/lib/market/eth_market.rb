# frozen_string_literal: true

module PaymiumMarket
  module Market
    class ETHMarket < PaymiumMarket::Market::Base

      # sets the database connector
      def initialize(db_connector = PaymiumMarket::Database::MysqlConnector.new("#{BASE}/#{QUOTE}"), fee = 0.25, fee_user_id = 1)
        @db = db_connector
        @base = 'eth'
        @quote = 'eur'
        @fee = fee
        @fee_user_id = fee_user_id
      end
    end
  end
end
