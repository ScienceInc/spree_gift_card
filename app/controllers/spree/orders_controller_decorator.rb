Spree::OrdersController.class_eval do
  before_filter :apply_gift_card, only: :update
  
  private
    def apply_gift_card
      return unless @order = current_order
      if @order.update_attributes(params[:order])
      	unless apply_gift_code
      		@order.state = "address"
      		@order.bill_address ||= Spree::Address.default
        	@order.ship_address ||= Spree::Address.default
        	render :edit and return
        end
      end
    end

end
