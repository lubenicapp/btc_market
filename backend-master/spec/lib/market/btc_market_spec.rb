# frozen_string_literal: true

RSpec.describe PaymiumMarket::Market::BTCMarket do
  subject(:market) { described_class.new(db) }
  let(:db) { instance_double(PaymiumMarket::Database::InMemoryConnector, create: 0) }
  let(:order) { instance_double(PaymiumMarket::Models::Order) }

  before do
    allow(db).to receive(:bids).and_return(bids)
    allow(db).to receive(:asks).and_return(asks)
  end

  let(:bids) { {} }
  let(:asks) { {} }

  describe '#submit' do
    subject(:submit) { market.submit(order) }

    context 'when called with an order' do
      it 'saves the order' do
        submit
        expect(db).to have_received(:create).with(order)
      end

      it 'returns the order id' do
        expect(submit).to eq(0)
      end
    end
  end

  describe '#market_price' do
    subject(:market_price) { market.market_price }

    context 'when there is no order' do
      it 'the market_price is 0' do
        expect(market_price).to eq(0)
      end
    end

    context 'when there are orders in both sides' do
      let(:bids) { { 0 => [5, 1] } }
      let(:asks) { { 1 => [2, 2] } }

      it 'the market_price is correct' do
        expect(market_price).to eq(3.5)
      end
    end
  end

  describe '#market_depth' do
    subject(:market_depth) { market.market_depth }

    let(:bids) { { 0 => [5, 1], 2 => [14, 1] } }
    let(:asks) { { 1 => [2, 2] } }

    let(:expected_result) do
      { 'bids' => [[14, 1], [5, 1]],
        'base' => 'BTC',
        'quote' => 'EUR',
        'asks' => [[2, 2]] }
    end

    it 'returns the correct market state with ordered orders' do
      expect(market_depth).to eq(expected_result)
    end
  end

  describe '#cancel_order' do
    subject(:cancel_order) { market.cancel_order(id) }
    let(:id) { 15 }

    before { allow(db).to receive(:delete).with(id).and_return(true) }

    context 'when called' do
      it 'deletes the id from the database' do
        cancel_order
        expect(db).to have_received(:delete).with(id)
      end
    end

    context 'when id exists' do
      it 'returns true' do
        expect(cancel_order).to eq(true)
      end
    end
  end
end
