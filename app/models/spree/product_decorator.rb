Spree::Product.class_eval do
  has_many :active_sale_events, :as => :eventable

  # Find live and active taxons for a product.
  def find_live_taxons
    Spree::ActiveSaleEvent.live_active.where(:eventable_type => "Spree::Taxon", :eventable_id => self.taxons.map{|t| t.self_and_ancestors}.flatten.map(&:id))
  end

  # if there is at least one active sale event which is live and active.
  def live?
    !self.active_sale_events.detect{ |event| event.live_and_active? }.nil? || !self.find_live_taxons.blank?
  end

  # Check if image is available for this.
  def image_available?
    !images.blank?
  end
end
