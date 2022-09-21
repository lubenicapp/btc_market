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

puts "### --- Create a fee user : "
user_fee_id = DATABASE[:users].insert(btc: '0', eur: '0')

puts

puts '### --- Create new market :'
market = PaymiumMarket::Market::BTCMarket.new(PaymiumMarket::Database::MysqlConnector.new, fee = 0.25, fee_user_id = user_fee_id)

puts

puts "market depth : #{market.market_depth}"
puts "market price : #{market.market_price}"

puts

puts '## --- Craeting users'

user_id_1 = DATABASE[:users].insert(btc: '12', eur: '45000')
user_id_2 = DATABASE[:users].insert(btc: '2', eur: '15000')

puts "user id: #{user_id_1}, btc: 12, eur: 45000"
puts "user id: #{user_id_2}, btc: 2, eur: 15000"

puts

puts '## adding orders'

order = PaymiumMarket::Models::Order.new(amount: 1, price: 1, side: 'buy', user_id: user_id_1)

puts "submit order : #{market.submit(order)}"
puts "submit order : #{market.submit(order)}"


order = PaymiumMarket::Models::Order.new(amount: 1, price: 1, side: 'sell', user_id: user_id_2)
puts "submit order : #{market.submit(order)}"
puts "submit order : #{market.submit(order)}"

puts

puts "market depth : #{market.market_depth}"
puts "market price : #{market.market_price}"

puts

puts '## matching order'

puts market.match

puts "btc balance"
puts "first user btc balance: #{DATABASE[:users].where(id: user_id_1).first[:btc].to_f}"
puts "second user btc balance: #{DATABASE[:users].where(id: user_id_2).first[:btc].to_f}"


puts "eur balance"
puts "first user eur balance: #{DATABASE[:users].where(id: user_id_1).first[:eur].to_f}"
puts "first user eur balance: #{DATABASE[:users].where(id: user_id_2).first[:eur].to_f}"

puts "market depth : #{market.market_depth}"

puts "fee user balance : #{DATABASE[:users].where(id: user_fee_id).first[:eur].to_f}"
