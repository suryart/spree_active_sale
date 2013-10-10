module Spree
  TaxonsController.class_eval do
    before_filter :load_view_type

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