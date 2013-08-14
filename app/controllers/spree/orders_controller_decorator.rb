Spree::OrdersController.class_eval do
  before_filter :apply_gift_card, only: :update
  
  private
    def apply_gift_card
      @order = current_order
      if @order.update_attributes(params[:order])
        render :edit and return unless apply_gift_code
      end
    end

end
