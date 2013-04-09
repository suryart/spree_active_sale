module Spree
  CheckoutController.class_eval do
    before_filter :check_active_products_in_order
    
  end
end