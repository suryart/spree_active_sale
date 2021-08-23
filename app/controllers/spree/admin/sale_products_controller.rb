module Spree
  module Admin
    class SaleProductsController < ResourceController
      belongs_to 'spree/active_sale_event', :find_by => :id
      prepend_before_action :load_data

      def create
        invoke_callbacks(:create, :before)
        @object.attributes = permitted_resource_params
        if @object.save
          invoke_callbacks(:create, :after)
          flash[:success] = flash_message_for(@object, :successfully_created)
          respond_with(@object) do |format|
            format.html { redirect_to location_after_save }
            format.js   { render layout: false }
          end
        else
          invoke_callbacks(:create, :fails)
          respond_with(@object) do |format|
            format.html { render action: :new }
            format.js { render layout: false }
          end
        end
      end

      def index
        respond_with(@sale_products)
      end

      private

        def collection_url
          admin_active_sale_active_sale_event_sale_products_url(@active_sale_event.active_sale, @active_sale_event)
        end

        def load_data
          @active_sale ||= Spree::ActiveSale.find_by_permalink!(params[:active_sale_id])
          @active_sale_event ||= Spree::ActiveSaleEvent.find(params[:active_sale_event_id])
          @sale_products ||= @active_sale_event.sale_products.page(params[:page]).per(SpreeActiveSale::Config[:admin_active_sale_event_products_per_page])
        end
    end
  end
end
