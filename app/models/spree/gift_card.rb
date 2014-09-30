require 'spree/core/validators/email'

module Spree
  class GiftCard < ActiveRecord::Base

    scope :unexpired_gift_codes, -> { where("expires_at > ?", DateTime.now - 1.days) }

    UNACTIVATABLE_ORDER_STATES = ["complete", "awaiting_return", "returned"]

    attr_accessible :email, :name, :note, :variant_id, :liability, :expires_at, :sender_name, :send_date, :image_id

    belongs_to :variant
    belongs_to :line_item
    belongs_to :image, class_name: 'Spree::GiftCardImage'

    has_many :transactions, class_name: 'Spree::GiftCardTransaction'

    validates :code,               presence: true, uniqueness: true
    validates :current_value,      presence: true
    validates :email, email: true, allow_blank: true
    validates :name,               presence: true
    validates :original_value,     presence: true

    before_validation :generate_code, on: :create
    before_validation :set_calculator, on: :create
    before_validation :set_values, on: :create

    delegate :image_url, to: :image
    delegate :thumbnail_url, to: :image

    include Spree::Core::CalculatedAdjustments

    def apply(order, label=false)
      # Nothing to do if the gift card is already associated with the order
      return if order.gift_credit_exists?(self)
      order.update!
      create_adjustment((label ? label : Spree.t(:gift_card)), order, order, true)
      order.update!
    end

    # Calculate the amount to be used when creating an adjustment
    def compute_amount(calculable)
      self.calculator.compute(calculable, self)
    end

    def debit(amount, order)
      raise 'Cannot debit gift card by amount greater than current value.' if (self.current_value - amount.to_f.abs) < 0
      transaction = self.transactions.build
      transaction.amount = amount
      transaction.order  = order
      self.current_value = self.current_value - amount.abs
      self.save
    end

    def price
      self.line_item ? self.line_item.price * self.line_item.quantity : self.variant.price
    end

    def order_activatable?(order)
      order &&
      current_value > 0 &&
      !UNACTIVATABLE_ORDER_STATES.include?(order.state) &&
      (line_item.nil? || (line_item.order.complete? && !line_item.order.canceled?))
    end

    public
    def self.total_liability
      sum(:liability)
    end

    def self.libalities
      pluck(:liability)
    end

    private

    def generate_code
      until self.code.present? && self.class.where(code: self.code).count == 0
        self.code = GiftCardConfig::CARD_PREFIX
        (16 - GiftCardConfig::CARD_PREFIX.length).times { self.code += Random.rand(0..9).to_s }
      end
    end

    def set_calculator
      self.calculator = Spree::Calculator::GiftCard.new
    end

    def set_values
      self.current_value  = self.variant.try(:price)
      self.original_value = self.variant.try(:price)
    end

  end
end
