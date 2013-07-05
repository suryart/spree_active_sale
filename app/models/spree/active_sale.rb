# ActiveSales
# Active sales represent an entity for one sale at a time, just like a taxonomy in spree.
# For example: 'January 2013' sale, which can have many sale events in it.
#
module Spree
  class ActiveSale < Spree::SaleEvent
    validates :name, :presence => true
    validate :start_and_end_date_presence, :start_and_end_date_range

    has_many :active_sale_events
    has_one :root, :conditions => { :parent_id => nil }, :class_name => "Spree::ActiveSaleEvent",
                   :dependent => :destroy

    before_save :have_valid_position
    after_save :set_root

    default_scope :order => "#{self.table_name}.position"

    def self.config(&block)
      yield(Spree::ActiveSaleConfig)
    end

    private
      def set_root
        root_hash = self.serializable_hash
        root_hash["active_sale_id"] = self.id
        root_hash["type"] = "Spree::ActiveSaleEvent"
        %w(id created_at updated_at lft rgt parent_id).each{ |column| root_hash.delete(column) }
        if root
          root.update_attributes(root_hash)
        else
          self.root = Spree::ActiveSaleEvent.create!(root_hash, :without_protection => true)
        end
      end

      def start_and_end_date_presence
        errors.add(:start_date, I18n.t('spree.active_sale.event.validation.errors.date_empty')) if self.start_date.nil?
        errors.add(:end_date, I18n.t('spree.active_sale.event.validation.errors.date_empty')) if self.end_date.nil?
      end

      # This should validate the start and end date range between
      # its active_sale_events. To make sure that, root lives longer.
      def start_and_end_date_range
        unless self.start_date.nil? || self.end_date.nil?
          oldest_start_date = self.active_sale_events.not_blank_and_sorted_by(:start_date).first
          latest_end_date = self.active_sale_events.not_blank_and_sorted_by(:end_date).last
          errors.add(:start_date, I18n.t('spree.active_sale.event.validation.errors.invalid_root_dates')) if (oldest_start_date.nil? && latest_end_date.nil?) ? false : (self.start_date > oldest_start_date || self.end_date < latest_end_date)
        end
      end
  end
end
