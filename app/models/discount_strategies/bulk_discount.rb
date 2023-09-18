# frozen_string_literal: true

module DiscountStrategies
  class BulkDiscount < Base
    class UnknownTypeError < StandardError; end

    PERCENTAGE = :percentage
    FIXED_PRICE = :fixed_price
    ALLOWED_OPERATIONS = [PERCENTAGE, FIXED_PRICE].freeze

    # If the product cost 5,
    # fixed_price with discount_value of 4.5 will make 0.5 of discount for every product
    # On percentage with discount_value of 20, will makes the product cost will be 4
    def initialize(order_item:, minimum_amount:, discount_value:, operation_type:)
      @order_item = order_item
      @minimum_amount = minimum_amount
      @discount_value = discount_value
      @operation_type = operation_type.to_sym
    end

    def apply
      raise ::DiscountStrategies::BulkDiscount::UnknownTypeError unless ALLOWED_OPERATIONS.include?(operation_type)
      return if order_item.nil? || order_item.discount_eligible_quantity < minimum_amount

      discount_amount = if operation_type == FIXED_PRICE
                          fixed_price_calculation
                        else
                          percentage_calculation
                        end

      { discount_amount:, used_items: order_item.discount_eligible_quantity }
    end

    private

    attr_accessor :order_item, :minimum_amount, :discount_value, :operation_type

    def fixed_price_calculation
      (order_item.original_product_price - discount_value) * order_item.discount_eligible_quantity
    end

    def percentage_calculation
      total = order_item.discount_eligible_quantity * order_item.original_product_price
      (discount_value / 100.0) * total
    end
  end
end
