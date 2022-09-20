# frozen_string_literal: true

require 'dry-initializer'

require_relative 'market'
require_relative 'models'
require_relative 'database'

module PaymiumMarket
  BUY = 'buy'
  SELL = 'sell'
end
