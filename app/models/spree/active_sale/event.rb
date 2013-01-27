# EVENTS
# Events represent an entity for active sale in a flash sale/ daily deal.
# There can be many events for one sale.
#
module Spree
  class ActiveSale::Event < ActiveRecord::Base
    include SpreeActiveSale::Eventable

    belongs_to :eventable, :polymorphic => true
    belongs_to :active_sale

    attr_accessible :description, :end_date, :eventable_id, :eventable_type, :is_active, :is_hidden, :is_permanent, :name, :permalink, :active_sale_id, :start_date

    validates :name, :presence => true
    validates :permalink, :presence => true
    validates :eventable_id, :presence => true, :uniqueness => { :scope => [:eventable_type, :active_sale_id] }
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
    scope :starting_today, lambda { where(:start_date => Time.now..Time.now.end_of_day) }
    scope :ending_today, lambda { where(:end_date => Time.now..Time.now.end_of_day) }

  end
end
