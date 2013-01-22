module SpreeActiveSale
  module Eventable
    module ClassMethods

      # Spree::ActiveSale::Event.is_live? method 
      # should only/ always represents live and active events and not just live events.
      def is_live? object
        object_class_name = object.class.name
        return (object.live_and_active?) if object_class_name == self.name
        %w(Spree::Product Spree::Variant Spree::Taxon).include?(object_class_name) ? object.live? : false
      end

      private
        def valid_argument args
          (args.first == nil || args.first == true)
        end
    end
    
    module InstanceMethods

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
    end
    
    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end