Spree::Product.class_eval do
  include Spree::ActiveSalesHelper

  has_many :active_sale_events, :as => :eventable

  # Find live and active taxons for a product.
  def find_live_taxons
    all_sale_events.select{ |sale_event| (sale_event.eventable_type == "Spree::Taxon") && (self.taxons.map(&:id).include?(sale_event.eventable_id)) }
  end

  # product.live_active_sale_event gets first active sale event which is live and active
  def live_active_sale_event
    get_sale_event(self)
  end

  # if there is at least one active sale event which is live and active.
  def live?
    !self.live_active_sale_event.nil? || !self.find_live_taxons.blank?
  end

  # Check if image is available for this.
  def image_available?
    !images.blank?
  end

  def image
    images.first
  end
end