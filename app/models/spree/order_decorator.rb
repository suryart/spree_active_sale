Spree::Order.class_eval do

  def delete_inactive_items
    self.line_items.each{ |line_item| line_item.destroy unless line_item.live? }
  end
end