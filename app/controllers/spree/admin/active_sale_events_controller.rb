module Spree
  module Admin
    class ActiveSaleEventsController < ResourceController
      belongs_to 'spree/active_sale', :find_by => :id
      before_filter :load_active_sale, :only => [:index]
      update.before :get_eventable

      def show
        redirect_to( :action => :edit )
      end

      def eventables
        search = params[:eventable_type].constantize.search(:name_cont => params[:name])
        render :json => search.result.map(&:name)
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
            parent.send(controller_name).build(params[object_name])
          else
            model_class.new(params[object_name])
          end
        end

        def get_eventable
          object_name = params[:active_sale_event]
          unless object_name[:eventable_type].nil?
            eventable = "#{object_name[:eventable_type]}".constantize.find_by_name(object_name[:eventable_name])
            object_name.delete(:eventable_name)
            unless eventable.nil?
              object_name.merge!(:eventable_id => eventable.id, :permalink => eventable.permalink)
            else
              object_name.merge!(:eventable_id => nil)
            end
          end
        end
    end
  end
end
