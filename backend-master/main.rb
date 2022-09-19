# frozen_string_literal: true

require_relative 'lib/btc_market'

###

market = BTCMarket::Market.new

puts '### new market :'

puts "market depth : #{market.market_depth}"
puts "market price : #{market.market_price}"


puts '## adding orders'

order = BTCMarket::Models::Order.new(10, 5, 'buy')

puts "submit order : #{market.submit(order)}"
puts "market depth : #{market.market_depth}"
puts "submit order : #{market.submit(order)}"
puts "market depth : #{market.market_depth}"

order = BTCMarket::Models::Order.new(5, 2.3, 'sell')
puts "submit order : #{market.submit(order)}"
puts "market price : #{market.market_price}"
puts "market depth : #{market.market_depth}"
puts "cancel order : #{market.submit(order)}"
puts "market depth : #{market.market_depth}"
