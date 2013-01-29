module Spree
  module ActiveSale::EventsHelper
    
    def sale_event_timer(event = nil)
      return I18n.t('spree.active_sale.event.can_not_be_nil') if (event == nil) || (event.class.name != "Spree::ActiveSale::Event")
      event.end_date.getlocal.strftime('%Y-%m-%dT%H:%M:%S')
    end
  end
end
