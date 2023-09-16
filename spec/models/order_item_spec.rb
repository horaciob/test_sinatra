# frozen_string_literal: true

# == Schema Information
#
# Table name: order_items
#
#  id                         :integer          not null, primary key
#  order_id                   :integer
#  product_code               :string
#  quantity                   :integer          default(1)
#  discount_eligible_quantity :integer
#  original_product_price     :decimal(100, 3)
#  total_price                :decimal(100, 3)
#  disccount                  :decimal(100, 3)
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#
RSpec.describe OrderItem, type: :model do
  subject { build(:order_item, :with_product, quantity: 10) }

  describe '#add_more_product' do
    context 'when add 3 more products' do
      before do
        subject.add_more_product(amount: 3)
      end

      it 'updates quantity' do
        expect(subject.quantity).to eq 13
      end

      it 'updates original_product_price' do
        expect(subject.original_product_price).to eq subject.product.price
      end

      it 'updates total_price' do
        expect(subject.total_price).to be_within(0.0001).of(13 * subject.product.price)
      end
    end
  end

  describe '#remove_product' do
    context 'when remove less element than the total' do
      before do
        subject.remove_product(amount: 3)
      end

      it 'updates quantity' do
        expect(subject.quantity).to eq 7
      end

      it 'updates original_product_price' do
        expect(subject.original_product_price).to eq subject.product.price
      end

      it 'updates total_price' do
        expect(subject.total_price).to be_within(0.0001).of(7 * subject.product.price)
      end
    end

    context 'when remove more than the amount of elements' do
      it 'returns false' do
        expect(subject.remove_product(amount: 11)).to be false
      end
    end
  end
end
