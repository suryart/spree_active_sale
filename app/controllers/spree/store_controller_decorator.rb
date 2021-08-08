module Spree
  module StoreControllerDecorator
    # Check if all products in cart are still live.
    # Also, delete line item if any of the products from cart is expired.
    def check_active_products_in_order
      current_order.delete_inactive_items unless current_order.nil?
    end
  end
end

Spree::StoreController.prepend(Spree::StoreControllerDecorator)
