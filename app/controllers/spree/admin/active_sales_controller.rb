module Spree
  module Admin
    class ActiveSalesController < ResourceController
      
      def index
        respond_with(@collection) do |format|
          format.html
          format.json { render :json => json_data }
        end
      end

      def show
        redirect_to edit_object_url(@active_sale)
      end

      protected

        def collection
          return @collection if @collection.present?
          @search = Spree::ActiveSale.includes(:active_sale_events).ransack(params[:q])
          @collection = @search.result.page(params[:page]).per(Spree::ActiveSaleConfig[:admin_active_sales_per_page])
        end
    end
  end
end
