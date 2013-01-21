# EVENTS
# Events represent an entity for active sale in a flash sale/ daily deal.
# There can be many events for one sale.
#
module Spree
  class ActiveSale::Event < ActiveRecord::Base
    belongs_to :eventable, :polymorphic => true
    belongs_to :active_sale

    attr_accessible :description, :end_date, :eventable_id, :eventable_type, :is_active, :is_hidden, :name, :permalink, :active_sale_id, :start_date

    validates :name, :presence => true
    validates :permalink, :presence => true
    validates :start_date, :presence => true
    validates :end_date, :presence => true
    validates :active_sale_id, :presence => true
    validate  :validate_start_and_end_date

    scope :live, lambda { where("(start_date <= :start_date AND end_date >= :end_date) OR is_permanent = :is_permanent", { :start_date => Time.now, :end_date => Time.now, :is_permanent => true }) }
    scope :active, lambda { |*args| where(:is_active => valid_argument(args)) }
    scope :hidden, lambda { |*args| where(:is_hidden => valid_argument(args)) }
    scope :live_active, lambda { |*args| self.live.active(valid_argument(args)) }
    scope :live_active_and_hidden, lambda { |*args| 
                            args = [{}] if [nil, true, false].include? args.first
                            self.live.active(valid_argument([args.first[:active]])).hidden(valid_argument([args.first[:hidden]])) 
                          }
    scope :upcoming_events, lambda { where("start_date > :start_date", { :start_date => Time.now }) }
    scope :starting_today, lambda { where(:start_date => Time.now.at_beginning_of_day..Time.now.end_of_day) }
    scope :ending_today, lambda { where(:end_date => Time.now.at_beginning_of_day..Time.now.end_of_day) }

    def validate_start_and_end_date
      errors.add(:start_date, I18n.t('spree.active_sale.event.validation.errors.invalid_dates')) if (self.start_date and self.end_date) and (self.start_date > self.end_date)
    end

    def live?
      current_time = Time.now
      (self.start_date <= current_time and self.end_date >= current_time) or self.is_permanent?
    end

    def live_and_active?
      self.live? and self.is_active?
    end

    # Spree::ActiveSale::Event.is_live? method 
    # should only/ always represents live and active events and not just live events.
    def self.is_live? object
      object_class_name = object.class.name
      return (object.live_and_active?) if object_class_name == self.name
      %w(Spree::Product Spree::Variant Spree::Taxon).include?(object_class_name) ? object.live? : false
    end

    private
      def self.valid_argument args
        (args.first == nil || args.first == true)
      end
  end
end
