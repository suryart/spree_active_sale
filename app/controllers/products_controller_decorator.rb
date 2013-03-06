module Spree
  ProductsController.class_eval do
    HTTP_REFERER_REGEXP = /^https?:\/\/[^\/]+\/t\/([a-z0-9\-\/]+)$/ unless defined? HTTP_REFERER_REGEXP

    def index
      redirect_to root_url, :error => t('spree.active_sale.event.flash.error')
    end

    def show
      @product = Spree::Product.active.find_by_permalink!(params[:id])
      return unless @product

      if @product.live?
        @variants = Spree::Variant.active.includes([:option_values, :images]).where(:product_id => @product.id)
        @product_properties = Spree::ProductProperty.includes(:property).where(:product_id => @product.id)

        referer = request.env['HTTP_REFERER']

        if referer && referer.match(HTTP_REFERER_REGEXP)
          @taxon = Spree::Taxon.find_by_permalink($1)
        end

        respond_with(@product)
      else
        redirect_to root_url, :error => t('spree.active_sale.event.flash.error')
      end
    end
  end
end