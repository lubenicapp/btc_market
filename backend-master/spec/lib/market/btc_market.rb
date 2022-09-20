# frozen_string_literal: true

RSpec.describe PaymiumMarket::Market::BTCMarket do
  subject(:market) { described_class.new(db) }
  let(:db) { instance_double(PaymiumMarket::DB::DBConnector) }
end
