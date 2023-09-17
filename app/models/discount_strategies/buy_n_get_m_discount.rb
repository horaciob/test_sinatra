# frozen_string_literal: true

module DiscountStrategies
  class BuyNGetMDiscount < Base
    def initialize(order_item:, buy:, free_amount:)
      @order_item = order_item
      @buy = buy
      @free_amount = free_amount
    end

    def apply
      return if order_item.discount_eligible_quantity < buy

      free_products = order_item.discount_eligible_quantity / (buy + free_amount)
      discount_amount = free_products * order_item.original_product_price
      used_items = (buy + free_amount) * free_products
      order_item.notify_discount(discount_amount, used_items)

      order_item
    end

    private

    attr_accessor :order_item, :buy, :free_amount
  end
end
