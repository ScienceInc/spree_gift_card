require_dependency 'spree/calculator'

module Spree
  class Calculator::FlatPercentItemTotal < Calculator
    preference :flat_percent, :decimal, :default => 0

    attr_accessible :preferred_flat_percent

    def self.description
      Spree.t(:flat_percent)
    end

    def compute(object)
      return unless object.present? and object.respond_to?(:item_total)
      items = object.line_items.select{|li| li.product.respond_to?(:is_gift_card?) ? (not li.product.is_gift_card?) : true }
      item_total = items.map(&:amount).sum
      value = item_total * BigDecimal(self.preferred_flat_percent.to_s) / 100.0
      (value * 100).round.to_f / 100
    end
  end
end
