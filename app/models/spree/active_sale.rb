# ActiveSales
# Active sales represent an entity for a group of sale events at a time.
# For example: 'My Sale/Product name' sale, which can have many schedules in it.
#
module Spree
  class ActiveSale < ActiveRecord::Base
    has_many :active_sale_events, -> { where(deleted_at: nil) }, :dependent => :destroy

    validates :name, :permalink, :presence => true
    validates :permalink, :uniqueness => true

    default_scope { order("#{self.table_name}.position") }

    accepts_nested_attributes_for :active_sale_events, :allow_destroy => true, :reject_if => lambda { |attrs| attrs.all? { |k, v| v.blank? } }

    before_validation :update_permalink

    def update_permalink
      self.permalink = self.name.parameterize if self.permalink.blank?
    end

    def self.config(&block)
      yield(SpreeActiveSale::Config)
    end

    # override the delete method to set deleted_at value
    # instead of actually deleting the sale.
    def delete
      self.update_column(:deleted_at, Time.zone.now)
      active_sale_events.update_all(:deleted_at => Time.zone.now)
    end

    def to_param
      permalink.present? ? permalink : (permalink_was || name.to_s.to_url)
    end

    def events
      self.active_sale_events
    end

    alias :schedules :events
  end
end
