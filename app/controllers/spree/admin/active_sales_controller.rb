module Spree
  module Admin
    class ActiveSalesController < ResourceController
      before_filter :load_active_sale_events, :only => [:new, :edit]
      before_filter :set_active_sale, :only => [:create, :update]
      respond_to :json, :only => [:get_children]

      def get_children
        @active_sale_events = Spree::ActiveSaleEvent.find(params[:parent_id]).children_sorted_by_position
        respond_with(@active_sale_events)
      end
      
      def index
        respond_with(@collection) do |format|
          format.html
          format.json { render :json => json_data }
        end
      end

      def show
        redirect_to edit_object_url(@active_sale)
      end

      def eventables
        search = params[:eventable_type].constantize.search(:name_cont => params[:name])
        render :json => search.result.map(&:name)
      end

      protected

        def collection
          return @collection if @collection.present?
          @search = Spree::ActiveSale.includes(:active_sale_events).ransack(params[:q])
          @collection = @search.result.page(params[:page]).per(Spree::ActiveSaleConfig[:admin_active_sales_per_page])
        end

        def load_active_sale_events
          if @active_sale.new_record?
            @active_sale_event = @active_sale.active_sale_events.build
          else
            @active_sale_event = @active_sale.root
            @active_sale_events = @active_sale.active_sale_events
          end
        end

        def set_active_sale
          return false if params[:active_sale_event].blank?
          params[:active_sale] = params[:active_sale_event]
          params[:active_sale].delete(:discount)
          object_name = params[:active_sale]
          get_eventable_object(object_name)
        end
    end
  end
end
