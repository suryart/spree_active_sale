Spree::Taxon.class_eval do
  has_many :active_sale_events, :as => :eventable, :class_name => "Spree::ActiveSale::Event"
end