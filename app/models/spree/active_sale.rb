# ActiveSales
# Active sales represent an entity for one sale at a time.
# For example: 'January 2013' sale, which can have many sale events in it.
#
module Spree
  class ActiveSale < ActiveRecord::Base
    has_many :active_sale_events
    belongs_to :taxon, :class_name => "Spree::Taxon"

    attr_accessible :name

    validates :name, :presence => true

    accepts_nested_attributes_for :active_sale_events, :allow_destroy => true, :reject_if => lambda { |attrs| attrs.all? { |k, v| v.blank? } }
  end
end
