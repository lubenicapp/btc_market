# frozen_string_literal: true

RSpec.describe PaymiumMarket::Database::MysqlConnector, integration: true do
  subject(:mysql_connector) { described_class.new }

  let(:db) do
    Sequel.connect(
      adapter: 'mysql2',
      user: ENV['DB_USERNAME'],
      host: ENV['DB_HOST'],
      database: ENV['DATABASE'],
      password: ENV['DB_PASSWORD']
    )
  end
  let(:users) { db[:users] }
  let(:orders) { db[:orders] }
  let(:user_id) { db[:users].first[:id] }

  before(:each) do
    orders.delete
    users.delete
    user_id = users.insert(btc: '10', eur: '15000')
    orders.insert(side: 'buy', amount: '1', price: '100', user_id: user_id, state: 'created', market: 'BTC/EUR')
    orders.insert(side: 'sell', amount: '2', price: '40', user_id: user_id, state: 'created', market: 'BTC/EUR')
  end

  after(:each) do
    orders.delete
    users.delete
  end

  describe '#create' do
    subject(:create) { mysql_connector.create(order) }
    let(:order) { PaymiumMarket::Models::Order.new(amount: 10, price: 2, side: 'buy', user_id: user_id) }

    context 'when creating an order for a user' do
      it 'is correctly created' do
        expect(create).to be >= 1
      end
    end

    context 'when user id does not exists' do
      let(:user_id) { -200 }
      it 'fails' do
        expect { create }.to raise_error(StandardError)
      end
    end
  end

  describe '#delete' do
    subject(:delete) { mysql_connector.delete(id) }

    context 'when deleting an existing order' do
      let(:id) { db[:orders].first[:id] }

      it 'returns true' do
        expect(delete).to be(true)
      end
    end

    context 'when deleting an non existing order' do
      let(:id) { -2000 }
      it 'returns false' do
        expect(delete).to be(false)
      end
    end
  end

  describe '#bids' do
    subject(:bids) { mysql_connector.bids }

    context 'when there are bids' do
      it 'returns a non empty collection' do
        expect(bids).not_to be_empty
      end
    end
  end

  describe '#asks' do
    subject(:asks) { mysql_connector.asks }

    context 'when there are bids' do
      it 'returns a non empty collection' do
        expect(asks).not_to be_empty
      end
    end
  end

  describe '#find_user_for_order' do
    subject(:find_user_for_order) { mysql_connector.find_user_for_order(order_id) }
    let(:order_id) { orders.where(side: 'buy').first[:id] }

    context 'when called on an existing order id' do
      it 'returns the right user' do
        expect(find_user_for_order[:btc]).to eq('10')
        expect(find_user_for_order[:eur]).to eq('15000')
      end
    end
  end

  describe '#change_user_balance' do
    subject(:change_user_balance) { mysql_connector.change_user_balance(user_id, token, amount) }

    context 'when token is btc' do
      let(:token) { 'btc' }
      let(:amount) { 2000 }

      it 'changes the btc balance' do
        change_user_balance
        expect(BigDecimal(db[:users].where(id: user_id).first[token.to_sym])).to eq(BigDecimal('2010.0'))
      end
    end
  end
end
