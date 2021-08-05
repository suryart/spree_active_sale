module Spree
  module OrderDecorator
    def delete_inactive_items
      self.line_items.each{ |line_item| line_item.destroy unless line_item.live? }
    end
  end
end

Spree::Order.prepend(Spree::OrderDecorator)
