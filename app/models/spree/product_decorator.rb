Spree::Product.class_eval do
  has_many :active_sale_events, :as => :eventable, :class_name => "Spree::ActiveSale::Event"

  def find_live_taxons
    Spree::ActiveSale::Event.live.where(eventable_type: "Spree::Taxon", eventable_id: self.taxons.map(&:id))
  end
end