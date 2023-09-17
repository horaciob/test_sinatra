# frozen_string_literal: true

RSpec.describe DiscountStrategies::BuyNGetMDiscount do
  describe '#apply' do
    context 'when it has 2 x 1' do
      let(:discount) do
        described_class.new(order_item:, buy: 1, free_amount: 1)
      end

      context 'when user buys 2' do
        let(:order_item) do
          create(:order_item, discount_eligible_quantity: 2,
                              original_product_price: 10.0, discount: 0)
        end

        it 'gets 1 for free' do
          discount.apply

          expect(order_item.discount).to eq(10.0)
          expect(order_item.discount_eligible_quantity).to eq(0)
        end
      end

      context 'when user buys 3' do
        let(:order_item) do
          create(:order_item, discount_eligible_quantity: 3,
                              original_product_price: 10.0, discount: 0)
        end

        it 'gets 1 free item' do
          discount.apply

          expect(order_item.discount).to eq(10.0)
          expect(order_item.discount_eligible_quantity).to eq(1)
        end
      end

      context 'when user buys 4' do
        let(:order_item) do
          create(:order_item, discount_eligible_quantity: 4,
                              original_product_price: 10.0, discount: 0)
        end

        it 'gets 2 free item' do
          discount.apply

          expect(order_item.discount).to eq(20.0)
          expect(order_item.discount_eligible_quantity).to eq(0)
        end
      end

      context 'when user buys 1001' do
        let(:order_item) do
          create(:order_item, discount_eligible_quantity: 1001,
                              original_product_price: 10.0, discount: 0)
        end

        it 'gets 500 free item' do
          discount.apply

          expect(order_item.discount).to eq(5000.0)
          expect(order_item.discount_eligible_quantity).to eq(1)
        end
      end
    end

    context 'when it has 5 x 7' do
      let(:discount) do
        described_class.new(order_item:, buy: 5, free_amount: 2)
      end

      context 'when user buys 103' do
        let(:order_item) do
          create(:order_item, discount_eligible_quantity: 103,
                              original_product_price: 10.0, discount: 0)
        end

        it 'gets 14 for free' do
          discount.apply

          expect(order_item.discount).to eq(140.0)
          expect(order_item.discount_eligible_quantity).to eq(5)
        end
      end
    end

    context 'when the order item is not eligible for the discount' do
      let(:order_item) do
        create(:order_item, discount_eligible_quantity: 2,
                            original_product_price: 10.0, discount: 0)
      end

      it 'does not apply the discount' do
        expect(order_item).not_to receive(:notify_discount)

        discount = described_class.new(order_item:, buy: 3, free_amount: 2)
        discount.apply
      end
    end
  end
end
