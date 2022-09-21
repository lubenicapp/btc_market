# frozen_string_literal: true

module PaymiumMarket
  module Market
    class BTCMarket < PaymiumMarket::Market::Base
      # sets the database connector
      def initialize(db_connector = PaymiumMarket::Database::MysqlConnector.new('BTC/EUR'), fee = 0.25, fee_user_id = 1)
        @db = db_connector
        @base = 'btc'
        @quote = 'eur'
        @fee = fee
        @fee_user_id = fee_user_id
      end
    end
  end
end
