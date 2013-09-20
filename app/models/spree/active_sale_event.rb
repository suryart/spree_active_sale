# EVENTS
# Events represent an entity for active sale in a flash sale/ daily deal.
# There can be many events for one sale.
#
module Spree
  class ActiveSaleEvent < ActiveRecord::Base
    # before_validation :update_permalink

    has_many :sale_images, :as => :viewable, :dependent => :destroy, :order => 'position ASC'
    has_many :sale_products, :dependent => :destroy, :order => "#{Spree::SaleProduct.table_name}.position ASC"
    has_many :products, :through => :sale_products, :order => "#{Spree::SaleProduct.table_name}.position ASC"
    has_many :sale_taxons, :dependent => :destroy, :order => "#{Spree::SaleTaxon.table_name}.position ASC"
    has_many :taxons, :through => :sale_taxons, :order => "#{Spree::SaleTaxon.table_name}.position ASC"

    # belongs_to :eventable, :polymorphic => true
    belongs_to :active_sale

    attr_accessible :description, :end_date, :is_active, :is_hidden, :is_permanent, :name, :permalink, :active_sale_id, :start_date, :discount, :taxon_ids, :shipping_category_id, :single_product_sale

    validates :name, :permalink, :start_date, :end_date, :active_sale_id, :presence => true

    # validate if there is no other sale with permalink is currently live and active
    validates :permalink, :uniqueness => { :message => I18n.t('spree.active_sale.event.validation.errors.live_event') }, :if => :live?
    validate  :validate_start_and_end_date

    make_permalink :order => :name

    class << self
      # Spree::ActiveSaleEvent.is_live? method 
      # should only/ always represents live and active events and not just live events.
      def is_live? object
        object_class_name = object.class.name
        return object.live_and_active? if object_class_name == self.name
        %w(Spree::Product Spree::Variant Spree::Taxon).include?(object_class_name) ? object.live? : false
      end

      def paginate(options = {})
        options = prepare_pagination(options)
        self.page(options[:page]).per(options[:per_page])
      end

      private

        def prepare_pagination(options)
          per_page = options[:per_page].to_i
          options[:per_page] = per_page > 0 ? per_page : Spree::ActiveSaleConfig[:active_sale_events_per_page]
          page = options[:page].to_i
          options[:page] = page > 0 ? page : 1
          options
        end
    end

    def to_param
      permalink.present? ? permalink : (permalink_was || name.to_s.to_url)
    end

    def live?(moment=object_zone_time)
      (self.start_date <= moment && self.end_date >= moment) || self.is_permanent? if start_and_dates_available?
    end

    def upcoming?(moment=object_zone_time)
      (self.start_date >= moment && self.end_date > self.start_date) if start_and_dates_available?
    end

    def past?(moment=object_zone_time)
      (self.start_date < moment && self.end_date > self.start_date && self.end_date < moment) if start_and_dates_available?
    end

    def live_and_active?(moment=nil)
      self.live?(moment) && self.is_active?
    end

    def update_permalink
      prefix = {"Spree::Taxon" => "t", "Spree::Product" => "products"}
      self.permalink = [prefix[self.eventable_type], self.eventable.permalink].join("/") unless self.eventable.nil?
    end

    def eventable_name
      eventable.try(:name)
    end

    def eventable_name=(name)
      self.eventable = self.eventable_type.constantize.find_by_name(name) if name.present?
    end

    def start_and_dates_available?
      self.start_date && self.end_date
    end

    def invalid_dates?
      self.start_and_dates_available? && (self.start_date >= self.end_date)
    end

    def eventable_image_available?
      !!eventable.try(:image_available?)
    end

    private

      def validate_start_and_end_date
        errors.add(:start_date, I18n.t('spree.active_sale.event.validation.errors.invalid_dates')) if invalid_dates?
      end

      def object_zone_time
        Time.zone.now
      end
  end
end

require_dependency 'spree/active_sale_event/scopes'