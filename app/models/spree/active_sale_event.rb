# EVENTS
# Events represent an entity for active sale in a flash sale/ daily deal.
# There can be many events for one sale.
#
module Spree
  class ActiveSaleEvent < ActiveRecord::Base
    include SpreeActiveSale::Eventable

    before_validation :update_permalink

    has_many :sale_images, :as => :viewable, :dependent => :destroy, :order => 'position ASC'
    belongs_to :eventable, :polymorphic => true
    belongs_to :active_sale

    attr_accessible :description, :end_date, :eventable_id, :eventable_type, :is_active, :is_hidden, :is_permanent, :name, :permalink, :active_sale_id, :start_date, :eventable_name, :discount

    validates :name, :permalink, :eventable_id, :start_date, :end_date, :active_sale_id, :presence => true
    validates :eventable_type, :presence => true, :uniqueness => { :scope => :eventable_id, :message => I18n.t('spree.active_sale.event.validation.errors.live_event') }, :if => :live?
    validate  :validate_start_and_end_date

    scope :live, lambda { where("(start_date <= :start_date AND end_date >= :end_date) OR is_permanent = :is_permanent", { :start_date => zone_time, :end_date => zone_time, :is_permanent => true }) }
    scope :active, lambda { |*args| where(:is_active => valid_argument(args)) }
    scope :hidden, lambda { |*args| where(:is_hidden => valid_argument(args)) }
    scope :live_active, lambda { |*args| self.live.active(valid_argument(args)) }
    scope :live_active_and_hidden, lambda { |*args| 
                            args = [{}] if [nil, true, false].include? args.first
                            self.live.active(valid_argument([args.first[:active]])).hidden(valid_argument([args.first[:hidden]])) 
                          }
    scope :upcoming_events, lambda { where("start_date > :start_date", { :start_date => zone_time }) }
    scope :past_events, lambda { where("end_date < :end_date", { :end_date => zone_time }) }
    scope :starting_today, lambda { where(:start_date => zone_time..zone_time.now.end_of_day) }
    scope :ending_today, lambda { where(:end_date => zone_time..zone_time.now.end_of_day) }

  end
end
