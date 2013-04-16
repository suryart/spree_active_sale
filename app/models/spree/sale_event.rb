# Sale Event
# Sale Event represents active sale and active sale event by using STI.
# There can be many events for one sale.
#
module Spree
  class SaleEvent < ActiveRecord::Base
    attr_accessible :description, :end_date, :eventable_id, :eventable_type, :is_active, :is_hidden, :is_permanent, :name, :permalink, :active_sale_id, :start_date, :eventable_name, :type, :parent_id, :position

    include SpreeActiveSale::Eventable

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
    scope :starting_today, lambda { where(:start_date => zone_time..zone_time.end_of_day) }
    scope :ending_today, lambda { where(:end_date => zone_time..zone_time.end_of_day) }

  end
end