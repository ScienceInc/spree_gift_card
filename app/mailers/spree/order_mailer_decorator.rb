Spree::OrderMailer.class_eval do
	def enqueue_giftcard_emails(gift_cards, resend = false)
		gift_cards.each do |gift_card|
			ConfirmationEmailWorker.enqueue({ mail: :gift_card_email,
																				line_item_id: gift_card.id,
																				resend: resend })
		end
	end

  def gift_card_email(options)
  	@options = options
    @gift_card = Spree::GiftCard.find_by_line_item_id(options[:line_item_id])
    subject = "#{@gift_card.sender_name} sent you a gift!"
    @gift_card.update_attribute(:sent_at, Time.now)
    mail(to: @gift_card.email, from: GiftCardConfig::FROM_EMAIL, subject: subject)
  end
end