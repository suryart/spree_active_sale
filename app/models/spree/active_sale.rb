# ActiveSales
# Active sales represent an entity for one sale at a time.
# For example: 'January 2013' sale, which can have many sale events in it.
#
module Spree
  class ActiveSale < Spree::SaleEvent
    acts_as_nested_set :dependent => :destroy
    has_many :active_sale_events

    validates :name, :presence => true

    accepts_nested_attributes_for :active_sale_events, :allow_destroy => true, :reject_if => lambda { |attrs| attrs.all? { |k, v| v.blank? } }

    def self.config(&block)
      yield(Spree::ActiveSaleConfig)
    end

    def children_and_active_sale_events
      ((self.descendants.map{ |child_sale| child_sale.children_and_active_sale_events } << self) + self.active_sale_events).flatten.reject(&:blank?)
    end
  end
end
