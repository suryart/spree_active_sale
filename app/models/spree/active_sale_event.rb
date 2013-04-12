# EVENTS
# Events represent an entity for active sale in a flash sale/ daily deal.
# There can be many events for one sale.
#
module Spree
  class ActiveSaleEvent < Spree::SaleEvent
    before_validation :update_permalink
    after_save :update_parent_active_sales

    has_many :sale_images, :as => :viewable, :dependent => :destroy, :order => 'position ASC'
    belongs_to :eventable, :polymorphic => true
    belongs_to :active_sale

    attr_accessible :description, :end_date, :eventable_id, :eventable_type, :is_active, :is_hidden, :is_permanent, :name, :permalink, :active_sale_id, :start_date, :eventable_name, :discount

    validates :name, :permalink, :eventable_id, :start_date, :end_date, :active_sale_id, :presence => true
    validates :eventable_type, :presence => true, :uniqueness => { :scope => :eventable_id, :message => I18n.t('spree.active_sale.event.validation.errors.live_event') }, :if => :live?
    validate  :validate_start_and_end_date

    # Spree::ActiveSaleEvent.is_live? method 
    # should only/ always represents live and active events and not just live events.
    def is_live? object
      object_class_name = object.class.name
      return object.live_and_active? if object_class_name == self.name
      %w(Spree::Product Spree::Variant Spree::Taxon).include?(object_class_name) ? object.live? : false
    end

    def update_permalink
      prefix = {"Spree::Taxon" => "t", "Spree::Product" => "products"}
      self.permalink = [prefix[self.eventable_type], self.eventable.permalink].join("/") unless self.eventable.nil?
    end

    # This callback basically makes sure that parents for an event lives longer.
    # Or at least parents live for the time when event is live.
    def update_parent_active_sales
      active_sale_events = active_sale.children_and_active_sale_events
      parents = active_sale.self_and_ancestors.flatten
      oldest_start_date = active_sale_events.select{|event| !event.start_date.blank? }.sort_by(&:start_date).first.start_date
      latest_end_date = active_sale_events.select{|event| !event.end_date.blank? }.sort_by(&:end_date).last.end_date
      parents.select{ |parent| parent.start_date.nil? ? true : (parent.start_date > oldest_start_date) }.each{ |sale| sale.update_attributes(:start_date => oldest_start_date) }
      parents.select{ |parent| parent.end_date.nil? ? true : (parent.end_date < latest_end_date) }.each{ |sale| sale.update_attributes(:end_date => latest_end_date) }
    end

    def eventable_name
      eventable.try(:name)
    end

    def eventable_name=(name)
      self.eventable = self.eventable_type.constantize.find_by_name(name) if name.present?
    end

    def eventable_image_available?
      !!eventable.try(:image_available?)
    end
  end
end
