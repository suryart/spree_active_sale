module Spree
  module Admin
    class ActiveSaleEventsController < ResourceController
      belongs_to 'spree/active_sale', :find_by => :permalink
      before_filter :load_active_sale, :only => [:index]
      before_filter :load_data, :except => [:index]

      def show
        session[:return_to] ||= request.referer
        redirect_to( :action => :edit )
      end

      def destroy
        @active_sale_event = Spree::ActiveSaleEvent.find(params[:id])
        @active_sale_event.delete

        flash.notice = I18n.t('spree.active_sale.notice_messages.event_deleted')

        respond_with(@active_sale_event) do |format|
          format.html { redirect_to collection_url }
          format.js  { render_js_for_destroy }
        end
      end

      def update
        if params[:active_sale_event][:taxon_ids].present?
          params[:active_sale_event][:taxon_ids] = params[:active_sale_event][:taxon_ids].split(',')
        end
        super
      end

      private
      
        def location_after_save
          edit_admin_active_sale_active_sale_event_url(@active_sale, @active_sale_event)
        end

      protected

        def collection
          return @collection if @collection.present?
          params[:q] ||= {}
          params[:q][:deleted_at_null] ||= "1"
          
          params[:q][:s] ||= "name asc"

          @search = super.ransack(params[:q])

          @search = Spree::ActiveSaleEvent.where(:active_sale_id => params[:active_sale_id]).ransack(params[:q])
          @collection = @search.result.page(params[:page]).per(Spree::ActiveSaleConfig[:admin_active_sale_events_per_page])
        end

        def load_active_sale
          @active_sale = Spree::ActiveSale.find_by_permalink!(params[:active_sale_id])
        end

        def load_data
          @taxons = Taxon.order(:name)
          @shipping_categories = ShippingCategory.order(:name)
        end
    end
  end
end
