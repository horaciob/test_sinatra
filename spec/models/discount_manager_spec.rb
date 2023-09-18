# frozen_string_literal: true

RSpec.describe DiscountManager, type: :model do
  describe '#apply' do
    let(:green_tea) { create(:product, name: 'Green Tea', code: 'GR1', price: 3.11) }
    let(:strawberries) { create(:product, name: 'Strawberries', code: 'SR1', price: 5.00) }
    let(:coffee) { create(:product, name: 'Coffee', code: 'CF1', price: 11.23) }

    context 'with Green tea promotion' do
      let(:order) do
        order = create(:order)
        order.add_product(product_code: green_tea.code, quantity: 2)
        order
      end

      it 'applies discounts correctly' do
        ret = described_class.new(order:).apply

        expect(ret.order_items.first.discount).to eq 3.11
        expect(ret.order_items.size).to eq 1
      end
    end

    context 'with strawberries promotion' do
      let(:order) do
        order = create(:order)
        order.add_product(product_code: strawberries.code, quantity: 1)
        order.add_product(product_code: strawberries.code, quantity: 1)
        order.add_product(product_code: green_tea.code, quantity: 1)
        order.add_product(product_code: strawberries.code, quantity: 1)
        order
      end

      it 'applies discounts correctly' do
        ret_order = described_class.new(order:).apply

        total = ret_order.order_items.sum(:total_price) - ret_order.order_items.sum(:discount)

        expect(total).to eq 16.61
      end
    end

    context 'with coffee promotion' do
      let(:order) do
        order = create(:order)

        order.add_product(product_code: green_tea.code, quantity: 1)
        order.add_product(product_code: coffee.code, quantity: 1)
        order.add_product(product_code: strawberries.code, quantity: 1)
        order.add_product(product_code: coffee.code, quantity: 2)
        order
      end

      it 'applies discounts correctly' do
        ret_order = described_class.new(order:).apply

        total = ret_order.order_items.sum(:total_price) - ret_order.order_items.sum(:discount)

        expect(total).to be_within(0.001).of(30.57)
      end
    end

    context 'with all promotions toghether' do
      let(:order) do
        order = create(:order)

        order.add_product(product_code: green_tea.code, quantity: 2)
        order.add_product(product_code: strawberries.code, quantity: 3)
        order.add_product(product_code: coffee.code, quantity: 3)
        order
      end

      it 'applies discounts correctly' do
        ret_order = described_class.new(order:).apply

        total_before_disscounts = ret_order.order_items.sum(:total_price)
        discount_total = ret_order.order_items.sum(:discount)
        total = total_before_disscounts - discount_total

        expect(total_before_disscounts).to be_within(0.01).of(54.91)
        expect(discount_total).to be_within(0.01).of(15.83)
        expect(total).to be_within(0.01).of(39.07)
      end
    end

    context 'with no promotions' do
      let(:order) do
        order = create(:order)

        order.add_product(product_code: green_tea.code, quantity: 1)
        order.add_product(product_code: strawberries.code, quantity: 2)
        order.add_product(product_code: coffee.code, quantity: 2)
        order
      end

      it 'applies discounts correctly' do
        ret_order = described_class.new(order:).apply

        total_before_disscounts = ret_order.order_items.sum(:total_price)
        discount_total = ret_order.order_items.sum(:discount)
        total = total_before_disscounts - discount_total

        expect(discount_total).to be_within(0.01).of(0)
        expect(total).to be_within(0.01).of(total_before_disscounts)
      end
    end
  end
end
