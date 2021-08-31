module Spree
  module Admin
    class ActiveSalesController < ResourceController
      before_action :load_data, :except => :index

      def index
        session[:return_to] = request.url
        respond_with(@collection)
      end

      def show
        session[:return_to] ||= request.referer
        redirect_to( :action => :edit )
      end

      def destroy
        @active_sale = Spree::ActiveSale.find_by_permalink!(params[:id])
        @active_sale.delete

        flash.notice = I18n.t('spree.active_sale.notice_messages.deleted')

        respond_with(@active_sale) do |format|
          format.html { redirect_to collection_url }
          format.js  { render_js_for_destroy }
        end
      end

      def search
        params[:q].blank? ? [] : @products = Spree::Product.limit(20).ransack(:name_cont => params[:q]).result
      end

      private
        def location_after_save
          edit_admin_active_sale_url(@active_sale)
        end

      protected

        def find_resource
          Spree::ActiveSale.find_by_permalink!(params[:id])
        end

        def load_data
          @taxons = Taxon.order(:name)
          @shipping_categories = ShippingCategory.order(:name)
          @promotions = Spree::PromotionCategory.active_sale.promotions
        end

        def collection
          return @collection if @collection.present?
          params[:q] ||= {}
          params[:q][:deleted_at_null] ||= "1"

          params[:q][:s] ||= "name asc"

          @search = super.ransack(params[:q])

          @search = Spree::ActiveSale.includes(:active_sale_events).ransack(params[:q])
          @collection = @search.result.page(params[:page]).per(SpreeActiveSale::Config[:admin_active_sales_per_page])
        end
    end
  end
end
