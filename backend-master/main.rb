# frozen_string_literal: true

require_relative 'lib/paymium_market'

DATABASE = Sequel.connect(
  adapter: 'mysql2',
  user: ENV['DB_USERNAME'],
  host: ENV['DB_HOST'],
  database: ENV['DATABASE'],
  password: ENV['DB_PASSWORD']
)

###

market = PaymiumMarket::Market::BTCMarket.new

puts '### new market :'

puts "market depth : #{market.market_depth}"
puts "market price : #{market.market_price}"

puts '## craeting users'

user_id_1 = DATABASE[:users].insert(btc: '12', eur: '45000')
user_id_2 = DATABASE[:users].insert(btc: '2', eur: '15000')

puts '## adding orders'

order = PaymiumMarket::Models::Order.new(amount: 10, price: 5, side: 'buy', user_id: user_id_1)

puts "submit order : #{market.submit(order)}"
puts "market depth : #{market.market_depth}"
puts "submit order : #{market.submit(order)}"
puts "market depth : #{market.market_depth}"

order = PaymiumMarket::Models::Order.new(amount: 5, price: 2.3, side: 'sell', user_id: user_id_2)
puts "submit order : #{market.submit(order)}"
puts "market price : #{market.market_price}"
puts "market depth : #{market.market_depth}"
puts "cancel order : #{market.submit(order)}"
puts "market depth : #{market.market_depth}"
