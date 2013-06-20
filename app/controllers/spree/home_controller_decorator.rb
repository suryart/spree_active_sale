module Spree
  HomeController.class_eval do
    include Spree::ActiveSalesHelper

    # List live and active sales on home page
    def index
      @sale_events = all_active_sale_events
      respond_with(@sale_events)
    end
  end
end