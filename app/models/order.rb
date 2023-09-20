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
class Order < ActiveRecord::Base
  has_many :order_items
  has_many :products, through: :order_items

  before_save :calculate_total

  enum status: { open: 'open', closed: 'closed' }
  validates :total, numericality: { greater_than_or_equal_to: 0, allow_blank: true }

  def add_product(product_code:, quantity: 1)
    return false if status == Order.statuses[:closed]

    order_item = order_items.find_or_initialize_by(product_code:)
    order_item.add_more_product(amount: quantity)
    order_item.save
  end

  def calculate_total
    return unless status_changed? && status == Order.statuses[:closed]

    self.total = order_items.sum(:total_price) - order_items.sum(:discount)
  end
end
