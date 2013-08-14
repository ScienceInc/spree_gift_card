Spree::CheckoutController.class_eval do

  # TODO Apply gift code in a before filter if possible to avoid overriding the update method for easier upgrades?
  # Updates the order and advances to the next state (when possible.)
  def update
    if @order.update_attributes(object_params)
      fire_event('spree.checkout.update')
      if @order.gift_code.present?
        render :edit and return unless apply_gift_code
      end
      return if after_update_attributes
  
      unless @order.next
        flash[:error] = Spree.t(:payment_processing_failed)
        redirect_to checkout_state_path(@order.state) and return
      end
  
      if @order.completed?
        session[:order_id] = nil
        flash.notice = Spree.t(:order_processed_successfully)
        flash[:commerce_tracking] = "nothing special"
        redirect_to completion_route
      else
        redirect_to checkout_state_path(@order.state)
      end
    else
      render :edit
    end
  end
  
  private
    def after_update_attributes
      if object_params && object_params[:coupon_code].present?
        coupon_result = Spree::Promo::CouponApplicator.new(@order).apply
        if !coupon_result[:coupon_applied?]
          @coupon_message = coupon_result[:error]
          respond_with(@order, :default_template => 'spree/api/orders/could_not_apply_coupon')
          return true
        end
      end
      false
    end

end