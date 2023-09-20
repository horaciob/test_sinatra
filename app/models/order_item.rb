# frozen_string_literal: true

# == Schema Information
#
# Table name: order_items
#
#  id                         :integer          not null, primary key
#  order_id                   :integer
#  product_code               :string
#  quantity                   :integer
#  discount_eligible_quantity :integer
#  original_product_price     :float
#  total_price                :float
#  discount                   :float
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#
class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product, primary_key: 'code', foreign_key: 'product_code'
  before_create :initialize_state
  after_save :calculate_totals

  validates :original_product_price, :total_price, :discount,
            numericality: { greater_than_or_equal_to: 0, allow_blank: true }

  validates :quantity, { greater_than_or_equal_to: 0, allow_blank: true, only_integer: true }
  def add_more_product(amount:)
    self.quantity = quantity.to_i + amount
    self.discount_eligible_quantity = quantity
    calculate_totals
  end

  def notify_discount(discount_amount:, used_items:)
    self.discount += discount_amount
    self.discount_eligible_quantity -= used_items
    save
  end

  def remove_product(amount:)
    return false if amount > quantity

    self.quantity = quantity.to_i - amount
    self.discount_eligible_quantity = quantity
    calculate_totals
  end

  private

  def initialize_state
    self.quantity = 0 if quantity.nil?
    self.discount = 0.0 if self.discount.nil?
    self.discount_eligible_quantity = quantity if self.discount_eligible_quantity.nil?
  end

  def calculate_totals
    self.original_product_price ||= product.price&.round(3)
    self.total_price = quantity * self.original_product_price
  end
end
