# frozen_string_literal: true

require 'dry-initializer'
require 'sequel'

require_relative 'market'
require_relative 'models'
require_relative 'database'
require_relative 'services'

module PaymiumMarket
  BUY = 'buy'
  SELL = 'sell'
  CREATED = 'created'
  FILLED = 'filled'
end
