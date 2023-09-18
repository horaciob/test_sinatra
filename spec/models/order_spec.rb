# frozen_string_literal: true

# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  total      :float
#  status     :string           default("open")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
RSpec.describe Order, type: :model do
  let!(:coffee_test) { create(:product, name: 'Coffee', price: 10.01) }
  let!(:tea_test) { create(:product, name: 'Tea', price: 3.03) }

  let!(:order_item_coffee) do
    create(:order_item,
           order: subject,
           product: coffee_test,
           total_price: 10.0,
           discount: 3.0)
  end
  let!(:order_item_tea) do
    create(:order_item, order: subject,
                        product: tea_test,
                        total_price: 3.3,
                        discount: 2.2)
  end

  context 'when an order change his status to close' do
    subject { create(:order, status: described_class.statuses[:open]) }

    it 'calculates his total' do
      subject.status = described_class.statuses[:closed]
      subject.save

      expect(subject.total).to be_within(0.001).of(8.1)
    end
  end

  describe 'add_product' do
    context 'when status is open' do
      subject { create(:order, status: described_class.statuses[:open]) }

      it 'do not add more items to the order' do
        order_item = subject.order_items.first
        order_item_quantity = order_item.quantity

        subject.add_product(product_code: order_item.product_code, quantity: 3)
        expect(subject.order_items.first.quantity).to eq order_item_quantity + 3
      end
    end

    context 'when status is closed' do
      subject { create(:order, status: described_class.statuses[:closed]) }

      it 'do not add more items to the order' do
        order_item = subject.order_items.first
        order_item_quantity = order_item.quantity
        expect(subject.add_product(product_code: order_item.product_code)).to be_falsey
        expect(subject.order_items.first.quantity).to eq order_item_quantity
      end
    end
  end
end
