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
FactoryBot.define do
  factory :order_item do
    quantity { 5 }
    discount_eligible_quantity { quantity }

    trait(:with_product) do
      product
    end
  end
end
