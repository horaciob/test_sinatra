# frozen_string_literal: true

module DiscountStrategies
  class Base
    def apply_discount
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end
  end
end
