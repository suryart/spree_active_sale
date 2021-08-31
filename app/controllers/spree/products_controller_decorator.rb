module Spree
  module ProductsControllerDecorator
    HTTP_REFERER_REGEXP = /^https?:\/\/[^\/]+\/t\/([a-z0-9\-\/]+)$/ unless defined? HTTP_REFERER_REGEXP

    module TrackerInclude
      def self.included(base)
        base.include ::Spree::BaseHelper

        # base.helper 'spree/trackers'
      end
    end

    def show
      @product = Spree::Product.active.find_by!(slug: params[:id])
      return unless @product

      if @product.live?
        @variants = Spree::Variant.active.includes([:option_values, :images]).where(:product_id => @product.id)
        @product_properties = Spree::ProductProperty.includes(:property).where(:product_id => @product.id)
        @product_price = @product.price_in(current_currency).amount

        referer = request.env['HTTP_REFERER']

        if referer && referer.match(HTTP_REFERER_REGEXP)
          @taxon = Spree::Taxon.find_by(slug: $1)
        end
        @product_images = product_images(@product, @variants)
      else
        redirect_to root_url, :error => t('spree.active_sale.event.flash.error')
      end
    end
  end
end

Spree::ProductsController.include(Spree::ProductsControllerDecorator::TrackerInclude)
Spree::ProductsController.prepend(Spree::ProductsControllerDecorator)
