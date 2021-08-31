module Spree
  module Admin
    class ActiveSaleEventsController < ResourceController
      belongs_to 'spree/active_sale', :find_by => :permalink
      before_action :load_active_sale, :only => [:index]
      before_action :load_data, :except => [:index]
      after_action :create_promotion, only: [:create]
      after_action :update_promotion, only: [:update]

      def show
        session[:return_to] ||= request.referer
        redirect_to( :action => :edit )
      end

      def destroy
        DestroyPromotion.call(active_sale_event: @active_sale_event)
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

        def create_promotion
          CreatePromotion.call(active_sale_event: @object)
        end

        def update_promotion
          UpdatePromotion.call(active_sale_event: @object)
        end

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
          @collection = @search.result.page(params[:page]).per(SpreeActiveSale::Config[:admin_active_sale_events_per_page])
        end

        def load_active_sale
          @active_sale = Spree::ActiveSale.find_by_permalink!(params[:active_sale_id])
        end

        def load_data
          @taxons = Taxon.order(:name)
          @shipping_categories = ShippingCategory.order(:name)
          @promotions = Spree::PromotionCategory.active_sale.promotions
        end
    end
  end
end
