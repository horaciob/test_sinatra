# frozen_string_literal: true

# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  total      :decimal(100, 3)
#  status     :string           default("open")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
RSpec.describe Order, type: :model do
  context 'when an order change his status to close' do
    subject { create(:order, status: 'open') }

    let!(:product1) { create(:product, price: 10.01) }
    let!(:product2) { create(:product, price: 3.03) }

    let!(:order_item1) do
      create(:order_item,
             order: subject,
             product: product1,
             total_price: 10.0,
             discount: 3.0)
    end
    let!(:order_item2) do
      create(:order_item, order: subject,
                          product: product2,
                          total_price: 3.3,
                          discount: 2.2)
    end

    it 'calculates his total' do
      subject.status = 'closed'
      subject.save

      expect(subject.total).to be_within(0.001).of(8.1)
    end
  end
end
