module Spree
  module PropertyDecorator
    def self.prepended(base)
      base.has_many :sale_properties, :dependent => :destroy
      base.has_many :active_sale_events, :through => :sale_properties
    end
  end
end

Spree::Property.prepend(Spree::PropertyDecorator)
