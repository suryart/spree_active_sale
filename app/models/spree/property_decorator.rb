module Spree
  Property.class_eval do
    has_many :sale_properties, :dependent => :destroy
    has_many :active_sale_events, :through => :sale_properties
  end
end