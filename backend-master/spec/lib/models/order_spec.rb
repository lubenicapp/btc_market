# frozen_string_literal: true

RSpec.describe PaymiumMarket::Models::Order do
  subject(:order) { described_class.new(amount: amount, price: price, side: side) }
  let(:amount) { 1 }
  let(:price) { 15_000 }
  let(:side) { PaymiumMarket::BUY }

  context 'when initialized' do
    it 'does not fail' do
      expect { order }.not_to raise_error
    end
  end
end
