module Spree
  module Admin
    class ActiveSalesController < ResourceController
      # GET /spree/active_sales
      # GET /spree/active_sales.json
      def index
        respond_with(@collection) do |format|
          format.html
          format.json { render :json => json_data }
        end
      end

      # GET /spree/active_sales/1
      # GET /spree/active_sales/1.json
      def show
        redirect_to( :action => :edit )
      end

      # GET /spree/active_sales/1/edit
      def edit
        @active_sale = Spree::ActiveSale.includes(:events).find(params[:id])
        respond_with(@collection) do |format|
          format.html
          format.json { render :json => json_data }
        end
      end

      protected

        def collection
          return @collection if @collection.present?
          @search = Spree::ActiveSale.includes(:events).ransack(params[:q])
          @collection = @search.result.page(params[:page]).per(Spree::ActiveSaleConfig[:admin_active_sales_per_page])
        end
    end
  end
end
