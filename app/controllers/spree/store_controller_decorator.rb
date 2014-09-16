Spree::StoreController.class_eval do

  protected

    def apply_gift_code
      return true if @order.gift_code.blank?
      #fixes for leading zeros chopped by Excel and users accidentally adding whitespace to codes
      @order.gift_code = "0" + @order.gift_code if @order.gift_code.length == 15
      @order.gift_code = @order.gift_code.gsub(/\s+/, '')
      if (gift_card = Spree::GiftCard.find_by_code(@order.gift_code)) and gift_card.order_activatable?(@order)
        fire_event('spree.checkout.gift_code_added', :gift_code => @order.gift_code)
        gift_card.apply(@order)
        flash[:notice] = Spree.t(:gift_code_applied)
        return true
      # Insane fix for codes that had their last digit rounded down to zero
      elsif @order.gift_code[-1] == "0"
        (1..9).each do |i|
          @order.gift_code[-1] = i.to_s
          if (gift_card = Spree::GiftCard.find_by_code(@order.gift_code)) and gift_card.order_activatable?(@order)
            fire_event('spree.checkout.gift_code_added', :gift_code => @order.gift_code)
            gift_card.apply(@order)
            flash[:notice] = Spree.t(:gift_code_applied)
            return true
          end
        end
        flash[:error] = Spree.t(:gift_code_not_found)
        return false
      else
        flash[:error] = Spree.t(:gift_code_not_found)
        return false
      end
    end

end