module Spree
  TaxonsController.class_eval do

    def show
      @taxon = Spree::Taxon.find_by_permalink!(params[:id])
      return unless @taxon

      if @taxon.live?
        @searcher = Spree::Config.searcher_class.new(params.merge(:taxon => @taxon.id))
        @products = @searcher.retrieve_products

        respond_with(@taxon)
      else
        redirect_to root_url, :error => t('spree.active_sale.event.flash.error')
      end
    end
  end
end