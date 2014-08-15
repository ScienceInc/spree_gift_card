class AddLiabilityAndExpiryDateToGiftCard < ActiveRecord::Migration
  def change
    add_column :spree_gift_cards, :liability, :decimal, :precision => 8, :scale => 2
    add_column :spree_gift_cards, :expires_at, :datetime, :default => DateTime.now + 2.months
  end
end
