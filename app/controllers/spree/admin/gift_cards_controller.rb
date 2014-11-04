module Spree
  module Admin
    class GiftCardsController < Spree::Admin::ResourceController
      before_filter :find_gift_card_variants, :except => [:destroy]

      def create
        count = params[:gift_card][:count].to_i
        params[:gift_card].delete(:count)
        count.times do |i|
          card = Spree::GiftCard.new(params[:gift_card])
          if card.save
            flash[:success] = count == 1 ? Spree.t(:successfully_created_gift_card) : Spree.t("Successfully created #{i} gift cards.")
          else
            render :new
          end
        end
        redirect_to admin_gift_cards_path
      end

      def search_by_code
        gift_card = Spree::GiftCard.find_by_code(params[:code])
        if gift_card
          @gift_cards = [gift_card]
        else
          @gift_cards = []
        end
        render :search
      end

      def search_by_order
        if order = Spree::Order.find_by_number(params[:order_number])
          card_line_items = order.line_items.select{|li| li.product.is_gift_card?}
          @gift_cards = card_line_items.collect{|c| c.gift_card}
        else
          @gift_cards = []
        end
        render :search
      end

      private
      def collection
        Spree::GiftCard.order("created_at desc").page(params[:page]).per(Spree::Config[:orders_per_page])
      end

      def find_gift_card_variants
        gift_card_product_ids = Product.not_deleted.where(is_gift_card: true).pluck(:id)
        @gift_card_variants = Variant.joins(:prices).where(["amount > 0 AND product_id IN (?)", gift_card_product_ids]).order("amount")
      end

    end
  end
end
