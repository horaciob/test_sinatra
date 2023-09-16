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
class Product < ActiveRecord::Base
  validates :name, :code, :price, presence: true
  validates :name, uniqueness: true
  validates :code, uniqueness: true
end
