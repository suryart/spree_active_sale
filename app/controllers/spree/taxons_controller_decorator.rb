module Spree
  module TaxonsControllerDecorator
    def self.prepended(base)
      base.before_action :load_view_type
    end

    def show
      @taxon = Spree::Taxon.find_by_permalink!(params[:id])
      return unless @taxon

      if @taxon.live?
        @searcher = Spree::Config.searcher_class.new(params.merge(:taxon => @taxon.id))
        @objects = @searcher.send(@retrieve_type) #retrieve_products

        respond_with(@taxon)
      else
        redirect_to root_url, :error => t('spree.active_sale.event.flash.error')
      end
    end

    private

    def load_view_type
      if params[:view_type].present? && params[:view_type] == 'sales'
        @view_type = 'sale_events'
        @retrieve_type = 'retrieve_sales'
      else
        @view_type = 'products'
        @retrieve_type = 'retrieve_products'
      end
    end
  end
end

Spree::TaxonsController.prepend(Spree::TaxonsControllerDecorator)
