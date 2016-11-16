module Spree
  class GiftCardsController < Spree::StoreController

  	def new
      redirect_to root_path and return
  		find_gift_card_variants
  		@gift_card = Spree::GiftCard.new
  		@card_images = Spree::GiftCardImage.ordered
  	end

  	def create
  		@gift_card = GiftCard.new(params[:gift_card])
      @gift_card.expires_at = nil
      if @gift_card.save
      	# Create line item
        line_item = LineItem.new(quantity: 1)
        line_item.gift_card = @gift_card
        line_item.variant = @gift_card.variant
        line_item.price = @gift_card.variant.price
        # Add to order
        order = current_order(true)
        order.line_items << line_item
        line_item.order = order
        order.save!
        # Save gift card
        @gift_card.line_item = line_item
        @gift_card.save!
        redirect_to params[:buy_another] == "true" ? new_gifts_path : cart_path
      else
      	render :new
      end
  	end

    private

    def find_gift_card_variants
      gift_card_product_ids = Product.not_deleted.where(is_gift_card: true).pluck(:id)
      available_amounts = spree_current_user.try(:consultant?) ? GiftCardConfig::AVAILABLE_CONSULTANT_AMOUNTS : GiftCardConfig::AVAILABLE_AMOUNTS
      @gift_card_variants = Variant.joins(:prices).where(["amount IN (?) AND product_id IN (?)", available_amounts, gift_card_product_ids]).order("amount")
    end

  end
end
