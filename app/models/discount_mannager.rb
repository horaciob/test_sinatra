# frozen_string_literal: true

class DiscountMannager
  attr_reader :order

  def initialize(order:)
    this.order = order
  end

  def apply; end
end
