class CreateGiftCardImages < ActiveRecord::Migration
  def change
    create_table :spree_gift_card_images do |t|
    	t.string :image_url
    	t.boolean :active, default: false
    	t.integer :order
    	t.timestamps
    end
  end
end
