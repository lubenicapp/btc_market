# frozen_string_literal: true

require_relative 'lib/paymium_market'

###

market = PaymiumMarket::BTCMarket.new

puts '### new market :'

puts "market depth : #{market.market_depth}"
puts "market price : #{market.market_price}"


puts '## adding orders'

order = PaymiumMarket::Models::Order.new(amount: 10, price: 5, side: 'buy')

puts "submit order : #{market.submit(order)}"
puts "market depth : #{market.market_depth}"
puts "submit order : #{market.submit(order)}"
puts "market depth : #{market.market_depth}"

order = PaymiumMarket::Models::Order.new(amount: 5, price: 2.3, side: 'sell')
puts "submit order : #{market.submit(order)}"
puts "market price : #{market.market_price}"
puts "market depth : #{market.market_depth}"
puts "cancel order : #{market.submit(order)}"
puts "market depth : #{market.market_depth}"
