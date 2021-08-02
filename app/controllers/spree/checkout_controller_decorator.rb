module Spree
  module CheckoutControllerDecorator
    def self.prepended(base)
      base.before_action :check_active_products_in_order
    end
  end
end

Spree::CheckoutController.prepend(Spree::CheckoutControllerDecorator)