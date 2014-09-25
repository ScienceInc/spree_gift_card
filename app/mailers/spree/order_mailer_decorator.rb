Spree::OrderMailer.class_eval do
  def gift_card_email(card_id, order_id)
    @gift_card = Spree::GiftCard.find(card_id)
    subject = "#{@gift_card.sender_name} Sent You a #{Spree::Config[:site_name]} Gift Card"
    @gift_card.update_attribute(:sent_at, Time.now)
    mail(to: @gift_card.email, from: GiftCardConfig::FROM_EMAIL, subject: subject)
  end
end