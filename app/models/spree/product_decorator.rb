Spree::Product.class_eval do
  has_many :active_sale_events, :as => :eventable

  def find_live_taxons
    Spree::ActiveSaleEvent.live_active.where(:eventable_type => "Spree::Taxon", :eventable_id => self.taxons.map{|t| t.self_and_ancestors}.flatten.map(&:id))
  end

  def live?
    !self.active_sale_events.detect{ |event| event.live_and_active? }.nil? || !self.find_live_taxons.blank?
  end
end
