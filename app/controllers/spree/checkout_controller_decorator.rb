Spree::CheckoutController.class_eval do
  after_filter :send_gift_card_emails, only: :update
  
  private
    def send_gift_card_emails
      if @order.completed?
        gift_cards = @order.line_items.select{|li| li.product.is_gift_card?}
        Spree::OrderMailer.enqueue_giftcard_emails(gift_cards) if gift_cards.any?
      end
    end

end