# frozen_string_literal: true

require 'dry-initializer'
require 'sequel'

require_relative 'services'
require_relative 'market'
require_relative 'models'
require_relative 'database'

module PaymiumMarket
  BUY = 'buy'
  SELL = 'sell'
  CREATED = 'created'
  FILLED = 'filled'
end
