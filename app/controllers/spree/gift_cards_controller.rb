module Spree
  class GiftCardsController < Spree::StoreController

    private

    def find_gift_card_variants
      gift_card_product_ids = Product.not_deleted.where(is_gift_card: true).pluck(:id)
      @gift_card_variants = Variant.joins(:prices).where(["amount > 0 AND product_id IN (?)", gift_card_product_ids]).order("amount")
    end

  end
end
