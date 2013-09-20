module Spree
  module Admin
    class SaleProductsController < ResourceController
      belongs_to 'spree/active_sale_event', :find_by => :permalink
      prepend_before_filter :load_data

      def index
        @sale_products = @active_sale_event.sale_products
        respond_with(@sale_products)
      end

      # def create

      # end

      private

        def build_resource
          # load_data
        end

        def load_resource
          @object = Spree::SaleProduct.new
        end

        def location_after_save
          admin_active_sale_active_sale_event_sale_products_url(@active_sale_event.active_sale, @active_sale_event)
        end

        def collection_url
          admin_active_sale_active_sale_event_sale_products_url(@active_sale_event.active_sale, @active_sale_event)
        end

        def load_data
          @active_sale = Spree::ActiveSale.find(params[:active_sale_id])
          @active_sale_event = Spree::ActiveSaleEvent.where('permalink = :id or id = :id', { :id => params[:active_sale_event_id] }).first
        end
    end
  end
end
