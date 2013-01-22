Spree::Taxon.class_eval do
  has_many :active_sale_events, :as => :eventable, :class_name => "Spree::ActiveSale::Event"

  def live?
    !self.active_sale_events.detect{ |event| event.live_and_active? }.nil?
  end
end