module Spree
  module Admin
    class SaleImagesController < ResourceController
      belongs_to 'spree/active_sale_event', :find_by => :id
      before_action :load_data

      create.before :set_viewable
      update.before :set_viewable
      destroy.before :destroy_before

      private
        def location_after_save
          admin_active_sale_active_sale_event_sale_images_url(@active_sale_event.active_sale, @active_sale_event)
        end

        def load_data
          @active_sale ||= Spree::ActiveSale.find_by_permalink!(params[:active_sale_id])
          @active_sale_event ||= Spree::ActiveSaleEvent.find(params[:active_sale_event_id])
        end

        def set_viewable
          @sale_image.viewable_type = 'Spree::ActiveSaleEvent'
          @sale_image.viewable_id = @active_sale_event.id
        end

        def destroy_before
          @viewable = @sale_image.viewable
        end

    end
  end
end
