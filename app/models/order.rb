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

  def add_product(product_code:, quantity: 1)
    return false if status.closed?

    order_item = order_items.find_or_initialize_by(product_code:)
    order_item.add_more_product(quantity:)
    order_item.save
  end

  def calculate_total
    return unless status_changed? && status == 'closed'

    self.total = order_items.sum(:total_price) - order_items.sum(:discount)
  end
end
