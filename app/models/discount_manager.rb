# frozen_string_literal: true

class DiscountManager
  attr_accessor :order

  PRODUCT_DISCOUNTS = [
    { product_code: 'GR1',
      discount_class: ::DiscountStrategies::BuyNGetMDiscount,
      opts: { buy: 1,
              free_amount: 1 } },
    { product_code: 'SR1',
      discount_class: ::DiscountStrategies::BulkDiscount,
      opts: { minimum_amount: 3,
              discount_value: 4.50,
              operation_type: ::DiscountStrategies::BulkDiscount::FIXED_PRICE } },
    { product_code: 'CF1', discount_class: ::DiscountStrategies::BulkDiscount,
      opts: { minimum_amount: 3,
              discount_value: 33.333333,
              operation_type: ::DiscountStrategies::BulkDiscount::PERCENTAGE } }
  ].freeze

  def initialize(order:)
    @order = order
  end

  def apply
    PRODUCT_DISCOUNTS.each do |product_discount|
      discount_class = product_discount[:discount_class]

      order_item = order.order_items.find_by(product_code: product_discount[:product_code])
      next unless order_item

      discount = discount_class.new(order_item:, **product_discount[:opts]).apply
      order_item.notify_discount(**discount) if discount
    end

    order
  end
end
