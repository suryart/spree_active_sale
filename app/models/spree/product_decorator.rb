Spree::Product.class_eval do
  has_many :sale_products
  has_many :active_sale_events, :through => :sale_products

  delegate :available, :to => :active_sale_events, :prefix => true
  delegate :live_active, :to => :active_sale_events, :prefix => true
  delegate :live_active_and_hidden, :to => :active_sale_events, :prefix => true

  # Find live and active taxons for a product.
  def find_live_taxons
    Spree::Taxon.joins([:active_sale_events, :products]).where({ :spree_products => {:id => self.id} }).merge(Spree::ActiveSaleEvent.available)
  end

  # if there is at least one active sale event which is live and active.
  def live?
    !self.active_sale_events_available.blank? || !self.find_live_taxons.blank?
  end
end