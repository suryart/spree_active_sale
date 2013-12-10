Spree::Taxon.class_eval do
  has_many :sale_taxons
  has_many :active_sale_events, :through => :sale_taxons

  # taxon.live_active_sale_events gets all sale events which is live and active
  def live_active_sale_events
    Spree::ActiveSaleEvent.joins(:taxons).where({ :spree_taxons => {:id => self.id} }).merge(Spree::ActiveSaleEvent.available)
  end

  # if there is at least one sale event which is live and active.
  def live?
    !self.live_active_sale_events.blank?
  end
end