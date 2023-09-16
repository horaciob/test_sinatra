# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    name { Faker::Coffee.variety }
    code { Faker::Alphanumeric.alphanumeric(number: 6) }
    price { rand(1..100.0) }

    trait(:with_description) do
      description { Faker::Food.description }
    end
  end
end
