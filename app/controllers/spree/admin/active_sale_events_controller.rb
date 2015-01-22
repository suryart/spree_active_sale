module Spree
  module Admin
    class ActiveSaleEventsController < ResourceController
      belongs_to 'spree/active_sale', :find_by => :id
      before_filter :load_active_sale, :only => [:index]
      before_filter :parent_id_for_event, :only => [:new, :edit, :create, :update]
      update.before :get_eventable
      respond_to :json, :only => [:update_events]

      def show
        redirect_to( :action => :edit )
      end

      def destroy
        @active_sale_event = Spree::ActiveSaleEvent.find(params[:id])
        @active_sale_event.destroy
        flash[:success] = flash_message_for(@active_sale_event, :successfully_removed)
        respond_with(@active_sale_event) do |format|
          format.html { redirect_to location_after_destroy }
          format.js   { render :partial => "spree/admin/shared/destroy" }
        end
      end

      def update_events
        @active_sale_event.update_attributes(active_sale_events_params)
        respond_with(@active_sale_event)
      end

      protected

        def collection
          return @collection if @collection.present?
          @search = Spree::ActiveSaleEvent.where(:active_sale_id => params[:active_sale_id]).ransack(params[:q])
          @collection = @search.result.page(params[:page]).per(Spree::ActiveSaleConfig[:admin_active_sale_events_per_page])
        end

        def load_active_sale
          @active_sale = Spree::ActiveSale.find(params[:active_sale_id])
        end

        def build_resource
          get_eventable unless params[object_name].nil?
          if parent_data.present?
            parent.send(controller_name).build(object_params)
          else
            model_class.new(params[object_name])
          end
        end

        def get_eventable
          object_name = params[:active_sale_event]
          get_eventable_object(object_name)
        end

        def parent_id_for_event
          params[:parent_id] ||= check_active_sale_event_params
          @parent_id = params[:parent_id]
          if @parent_id.blank?
            redirect_to edit_admin_active_sale_path(params[:active_sale_id]), :notice => I18n.t('spree.active_sale.event.parent_id_cant_be_nil')
          end
        end

        def check_active_sale_event_params(event = params[:active_sale_event])
          return nil if event.nil?
          parent_id = event[:parent_id]
          event.delete(:parent_id) if event[:parent_id].nil? || event[:parent_id] == "nil"
          parent_id
        end

      private

        def object_params
          if params[object_name].present?
            params[object_name].permit(:description, :end_date, :eventable_id, :eventable_type, :is_active, :is_hidden, :is_permanent, :name, :permalink, :active_sale_id, :start_date, :eventable_name, :discount, :parent_id)
          end
        end

        def active_sale_events_params
            params.require(:active_sale_event).permit(:position, :parent_id)
        end

    end
  end
end
