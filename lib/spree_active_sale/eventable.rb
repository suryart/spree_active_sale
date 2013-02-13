# encoding: utf-8

module SpreeActiveSale
  module Eventable
    module ClassMethods

      # Spree::ActiveSale::Event.is_live? method 
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
        def valid_argument args
          (args.first == nil || args.first == true)
        end

        def prepare_pagination(options)
          per_page = options[:per_page].to_i
          options[:per_page] = per_page > 0 ? per_page : Spree::ActiveSaleConfig[:active_sale_events_per_page]
          page = options[:page].to_i
          options[:page] = page > 0 ? page : 1
          options
        end
    end
    
    module InstanceMethods

      def validate_start_and_end_date
        errors.add(:start_date, I18n.t('spree.active_sale.event.validation.errors.invalid_dates')) if (self.start_date and self.end_date) and (self.start_date >= self.end_date)
      end

      def live?
        current_time = Time.zone.now
        (self.start_date <= current_time and self.end_date >= current_time) or self.is_permanent?
      end

      def live_and_active?
        self.live? and self.is_active?
      end

      def update_permalink
        prefix = {"Spree::Taxon" => "t", "Spree::Product" => "products"}
        self.permalink = [prefix[self.eventable_type], self.eventable.permalink].join("/")
      end

      def eventable_name
        eventable.try(:name)
      end

      def eventable_name=(name)
        self.eventable = self.eventable_type.constantize.find_by_name(name) if name.present?
      end
    end
    
    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end