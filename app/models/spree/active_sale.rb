# ActiveSales
# Active sales represent an entity for a group of sale events at a time.
# For example: 'January 2013' sale, which can have many sale events frpm January in it.
#
module Spree
  class ActiveSale < ActiveRecord::Base
    has_many :active_sale_events, :conditions => { :deleted_at => nil }
    # belongs_to :taxon, :class_name => "Spree::Taxon"

    attr_accessible :name

    validates :name, :presence => true

    default_scope :order => "#{self.table_name}.position"

    accepts_nested_attributes_for :active_sale_events, :allow_destroy => true, :reject_if => lambda { |attrs| attrs.all? { |k, v| v.blank? } }

    def self.config(&block)
      yield(Spree::ActiveSaleConfig)
    end

    # override the delete method to set deleted_at value
    # instead of actually deleting the product.
    def delete
      self.update_column(:deleted_at, Time.zone.now)
      active_sale_events.update_all(:deleted_at => Time.zone.now)
    end
  end
end
