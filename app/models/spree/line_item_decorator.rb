module Spree
  module LineItemDecorator
    def live?
      self.product.live?
    end
  end
end

Spree::LineItem.prepend(Spree::LineItemDecorator)
