Spree::LineItem.class_eval do

  def live?
    self.product.live?
  end
end