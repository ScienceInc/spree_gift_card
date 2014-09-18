class AddSendDateAndSenderNameToSpreeGiftCard < ActiveRecord::Migration
  def change
  	add_column :spree_gift_cards, :send_date, :datetime
  	add_column :spree_gift_cards, :sender_name, :string
  	add_column :spree_gift_cards, :image_id, :integer

  	add_index :spree_gift_cards, :image_id
  end
end
