module Spree
  module HomeControllerDecorator
    # List live, not hidden and active sales on home page
    def index
      @searcher = Spree::Config.searcher_class.new(params)
      @searcher.current_user = try_spree_current_user
      @searcher.current_currency = current_currency
      @sale_events = @searcher.retrieve_sales
      respond_with(@sale_events)
    end
  end
end

Spree::HomeController.prepend(Spree::HomeControllerDecorator)
