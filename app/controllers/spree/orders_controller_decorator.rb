module Spree
  module OrdersControllerDecorator
    module TrackerInclude
      def self.included(base)
        base.include ::Spree::BaseHelper

        # base.helper 'spree/trackers'
      end
    end

    def self.prepended(base)
      base.before_action :check_active_products_in_order
    end
  end
end

Spree::OrdersController.include(Spree::OrdersControllerDecorator::TrackerInclude)
Spree::OrdersController.prepend(Spree::OrdersControllerDecorator)
