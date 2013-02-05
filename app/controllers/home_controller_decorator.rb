module Spree
  HomeController.class_eval do

    def index
      @sale_events = Spree::ActiveSale::Event.live_active
      respond_with(@sale_events)
    end
  end
end