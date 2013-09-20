Spree::Taxon.class_eval do
  has_many :sale_taxons
  has_many :active_sale_events, :through => :sale_taxons

  # taxon.live_active_sale_event gets first active sale event which is live and active
  def live_active_sale_event
    get_sale_event(self)
  end

  # if there is at least one active sale event which is live and active.
  def live?
    !self.live_active_sale_event.nil?
  end

  def image_available?
    icon?
  end

  def image
    icon
  end
end