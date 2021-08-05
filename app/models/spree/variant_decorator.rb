# This decorator is created by keeping that in mind
# what is when a user may need or want a sale event on
# an SKU or a Variant level. Variant needs to reflect the
# same on admin dashboard for selection from dropdrown in
# edit and new view pages.
#

module Spree
  module VariantDecorator
    def self.prepended(base)
      base.include Spree::ActiveSalesHelper

      base.has_many :active_sale_events, :as => :eventable
    end

    # variant.live_active_sale_event gets first active sale event which is live and active
    def live_active_sale_event
      get_sale_event(self)
    end

    def live?
      !self.live_active_sale_event.nil? || self.product.live?
    end
  end
end

Spree::Variant.prepend(Spree::VariantDecorator)
