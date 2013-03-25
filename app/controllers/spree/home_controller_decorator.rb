module Spree
  HomeController.class_eval do

    # List live and active sales on home page
    def index
      @sale_events = Spree::ActiveSaleEvent.live_active
      respond_with(@sale_events)
    end
  end
end