# frozen_string_literal: true

RSpec.describe PaymiumMarket::Market::BTCMarket do
  subject(:market) { described_class.new(db) }
  let(:db) { instance_double(PaymiumMarket::DB::DBConnector, create: 0) }
  let(:order) { instance_double(PaymiumMarket::Models::Order) }

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
    before { allow(db).to receive(:bids).and_return(bids) }
    before { allow(db).to receive(:asks).and_return(asks) }

    context 'when there is no order' do
      let(:bids) { {} }
      let(:asks) { {} }

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

end
