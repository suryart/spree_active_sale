module Spree
  module ActiveSalesHelper
    # Getter to load all_sale_events
    # Get the helper and load from cache when possible
    def all_sale_events
      @all_sale_events ||= Spree::SaleEvent.live_active
    end

    # Setter to set all_sale_events.
    # Set the helper and load from parameter when possible
    def all_sale_events=(sale_events)
      return Array.new unless sale_events.class == Array
      @all_sale_events = sale_events
    end

    # Get the helper and load from cache when possible
    def all_active_sale_events
      all_sale_events.select{ |e| e.type == "Spree::ActiveSaleEvent" && e.parent_id != nil }
    end

    # find sale event for the product or a taxon
    # pass taxon or product object in the argument
    def get_sale_event(object)
      if ["Spree::Product", "Spree::Taxon"].include? object.class.name
        active_sale_event = all_sale_events.detect{ |sale_event| (sale_event.eventable_type == object.class.name) && (sale_event.eventable_id == object.id) }
      end
      active_sale_event
    end

    # helper to load current_active_sale_event
    def current_active_sale_event
      all_sale_events.detect{ |sale_event| current_permalink?(sale_event.permalink) }
    end

    def current_active_sale_event=(active_sale_event)
      active_sale_event.nil? ? current_active_sale_event : active_sale_event
    end

    # check for current permalink using request
    # split with "?" as there can be parameters
    def current_permalink?(permalink = nil)
      return false if permalink.blank?
      request.path.split('/').reject(&:blank?).join('/') == permalink
    end
  end
end
