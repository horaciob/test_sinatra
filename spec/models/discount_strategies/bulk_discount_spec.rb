# frozen_string_literal: true

# spec/models/bulk_discount_spec.rb
RSpec.describe DiscountStrategies::BulkDiscount do
  let(:order_item) do
    create(:order_item,
           discount_eligible_quantity: 6,
           original_product_price: 20.0)
  end

  describe '#apply' do
    subject { discount.apply }

    context 'when fixed_price' do
      context 'when is aplicable' do
        let(:discount) do
          described_class.new(order_item:, minimum_amount: 5,
                              discount_value: 18.0,
                              operation_type: :fixed_price)
        end

        it 'applies the fixed_price discount correctly' do
          expect(subject[:discount_amount]).to eq(12.0)
          expect(subject[:used_items]).to eq(6)
        end
      end

      context 'when not applicable' do
        let(:discount) do
          described_class.new(order_item:, minimum_amount: 7,
                              discount_value: 1.1,
                              operation_type: :fixed_price)
        end

        it 'do not applies any disccount if discount_eligible_quantity is less than expected' do
          expect(subject).to be_falsey
        end
      end
    end

    context 'when percentage' do
      let(:discount) do
        described_class.new(order_item:, minimum_amount: 5,
                            discount_value: 50.0,
                            operation_type: :percentage)
      end

      context 'when it is applicable' do
        it 'applies the percentage discount correctly' do
          expect(subject[:discount_amount]).to eq(60.0)
          expect(subject[:used_items]).to eq(6)
        end

        context 'when it is applicable' do
          let(:discount) do
            described_class.new(order_item:,
                                minimum_amount: 10,
                                discount_value: 50.0,
                                operation_type: :percentage)
          end

          it 'applies the percentage discount correctly' do
            expect(subject).to be_falsey
          end
        end
      end
    end

    context 'when the operation type is unknown' do
      it 'raises an UnknownType error' do
        expect do
          described_class.new(order_item:, minimum_amount: 5, discount_value: 20.0,
                              operation_type: :invalid_type).apply
        end.to raise_error(DiscountStrategies::BulkDiscount::UnknownTypeError)
      end
    end
  end
end
