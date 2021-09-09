module Spree
  module Admin
    class ActiveSaleEventsController < ResourceController
      belongs_to 'spree/active_sale', :find_by => :permalink
      before_action :load_active_sale, :only => [:index]
      before_action :load_data, :except => [:index]

      def create
        active_sale_event_params = permitted_resource_params.merge(active_sale_id: @active_sale.id)
        context = ActiveSale::ActiveSaleEventCreator.call(params: active_sale_event_params)
        @active_sale_event = context.active_sale_event

        if context.success
          flash[:success] = flash_message_for(@active_sale_event, :successfully_created)
          respond_with(@active_sale_event) do |format|
            format.html { redirect_to location_after_save }
            format.js   { render layout: false }
          end
        else
          respond_with(@active_sale_event) do |format|
            format.html { render action: :new }
            format.js { render layout: false }
          end
        end
      end

      def update
        context = ActiveSale::ActiveSaleEventUpdater.call(active_sale_event: @object, params: permitted_resource_params)
        if context.success
          respond_with(@object) do |format|
            format.html do
              flash[:success] = flash_message_for(@object, :successfully_updated)
              redirect_to location_after_save
            end
            format.js { render layout: false }
          end
        else
          invoke_callbacks(:update, :fails)
          respond_with(@object) do |format|
            format.html { render action: :edit }
            format.js { render layout: false }
          end
        end
      end

      def show
        session[:return_to] ||= request.referer
        redirect_to( :action => :edit )
      end

      def destroy
        ActiveSale::ActiveSaleEventDestroyer.call(active_sale_event: @active_sale_event)

        flash.notice = I18n.t('spree.active_sale.notice_messages.event_deleted')

        respond_with(@active_sale_event) do |format|
          format.html { redirect_to collection_url }
          format.js  { render_js_for_destroy }
        end
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
          @collection = @search.result.page(params[:page]).per(SpreeActiveSale::Config[:admin_active_sale_events_per_page])
        end

        def load_active_sale
          @active_sale = Spree::ActiveSale.find_by_permalink!(params[:active_sale_id])
          @active_sale_events = @active_sale.active_sale_events
        end

        def load_data
          @taxons = Taxon.order(:name)
          @shipping_categories = ShippingCategory.order(:name)
          @promotions = Spree::PromotionCategory.active_sale.promotions
        end
    end
  end
end
