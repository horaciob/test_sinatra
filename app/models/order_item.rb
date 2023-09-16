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
class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product, primary_key: 'code', foreign_key: 'product_code'

  after_save :calculate_totals

  def add_more_product(amount:)
    self.quantity = quantity.to_i + amount
    calculate_totals
  end

  def remove_product(amount:)
    return false if amount > quantity

    self.quantity = quantity.to_i - amount
    calculate_totals
  end

  private

  def calculate_totals
    self.original_product_price ||= product.price&.round(3)
    self.total_price = quantity * self.original_product_price
  end
end
