module Spree
  CheckoutController.class_eval do
    before_filter :check_active_products_in_order

    # Check if all products in cart are still live.
    # Also, delete line item if any of the products from cart is expired.
    def check_active_products_in_order
      @order.line_items.select{ |line_item| !line_item.product.live? }.destroy_all
    end
  end
end