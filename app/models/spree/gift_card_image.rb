module Spree
  class GiftCardImage < ActiveRecord::Base
  	attr_accessible :image_url, :order, :active

  	scope :ordered, where(active: true).order("spree_gift_card_images.order ASC NULLS LAST")

  end
end