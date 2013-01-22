Spree::Product.class_eval do
  has_many :active_sale_events, :as => :eventable, :class_name => "Spree::ActiveSale::Event"

  def find_live_taxons
    Spree::ActiveSale::Event.live_active.where(:eventable_type => "Spree::Taxon", :eventable_id => self.taxons.map(&:id))
  end

  def live?
    !self.active_sale_events.detect{ |event| event.live_and_active? }.nil? || !self.find_live_taxons.blank?
  end
end