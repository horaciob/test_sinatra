# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  code        :string           not null
#  description :text
#  price       :float            not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :product do
    name { Faker::Food.dish }
    code { Faker::Alphanumeric.alphanumeric(number: 6) }
    price { rand(1..100.0).round(3) }

    trait(:with_description) do
      description { Faker::Food.description }
    end
  end
end
