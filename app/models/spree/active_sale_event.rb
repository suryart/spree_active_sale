# EVENTS
# Events represent an entity for active sale in a flash sale/ daily deal.
# There can be many events for one sale, just like taxonomies in spree.
#
module Spree
  class ActiveSaleEvent < Spree::SaleEvent
    acts_as_nested_set :dependent => :destroy, :polymorphic => true

    before_validation :update_permalink
    before_save :have_valid_position
    after_save :update_parent_active_sales, :update_active_sale_position

    has_many :sale_images, :as => :viewable, :dependent => :destroy, :order => 'position ASC'
    belongs_to :eventable, :polymorphic => true
    belongs_to :active_sale

    attr_accessible :description, :end_date, :eventable_id, :eventable_type, :is_active, :is_hidden, :is_permanent, :name, :permalink, :active_sale_id, :start_date, :eventable_name, :discount, :parent_id

    validates :name, :permalink, :eventable_id, :start_date, :end_date, :active_sale_id, :presence => true
    validates :eventable_type, :presence => true, :uniqueness => { :scope => :eventable_id, :message => I18n.t('spree.active_sale.event.validation.errors.live_event') }, :if => :live?

    scope :non_parents, lambda { where('parent_id IS NOT NULL') }

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
      active_sale_events = self.self_and_ancestors
      parents = self.ancestors
      oldest_start_date = active_sale_events.not_blank_and_sorted_by(:start_date).first
      latest_end_date = active_sale_events.not_blank_and_sorted_by(:end_date).last
      parents.each{ |parent| 
        parent.update_attributes(:start_date => oldest_start_date) if parent.start_date.nil? ? true : (parent.start_date > oldest_start_date) 
        parent.update_attributes(:end_date => latest_end_date) if parent.end_date.nil? ? true : (parent.end_date < latest_end_date)
      }
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

    def children_sorted_by_position
      self.children.sort_by{ |child| child.position.nil? ? 0 : child.position }
    end

    private
    def update_active_sale_position
      return true unless active_sale.position.nil?
      active_sale = self.active_sale
      active_sale.position = nil
      active_sale.save
    end
  end
end
