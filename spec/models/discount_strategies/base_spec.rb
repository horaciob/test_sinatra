# frozen_string_literal: true

RSpec.describe DiscountStrategies::Base, type: :model do
  describe '#apply_discount' do
    it 'raises a NotImplementedError' do
      base = described_class.new

      expect { base.apply_discount }.to raise_error(NotImplementedError)
    end
  end
end
