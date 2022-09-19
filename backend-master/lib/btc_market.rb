# frozen_string_literal: true

require_relative 'market'
require_relative 'models/order'
require_relative 'db/db_connector'

module BTCMarket
  BUY = 'buy'
  SELL = 'sell'
  BASE = 'BTC'
  QUOTE = 'EUR'
end
