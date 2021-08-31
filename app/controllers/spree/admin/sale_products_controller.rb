module Spree
  module Admin
    class SaleProductsController < ResourceController
      belongs_to 'spree/active_sale_event', :find_by => :id
      prepend_before_action :load_data
      after_action :create_product_promotion_rule, only: [:create]
      before_action :destroy_product_promotion_rule, only: [:destroy]

      def create_product_promotion_rule
        Spree::ProductPromotionRule.create(
          product_id: @object.product_id,
          promotion_rule_id: @object.active_sale_event.promotion_rules.first.id,
          preferences: nil
        )
      end

      def destroy_product_promotion_rule
        Spree::ProductPromotionRule.find_by(
          product_id: @object.product_id,
          promotion_rule_id: @object.active_sale_event.promotion_rules.first.id,
        ).destroy
      end

      def index
        respond_with(@sale_products)
      end

      private

        def collection_url
          admin_active_sale_active_sale_event_sale_products_url(@active_sale_event.active_sale, @active_sale_event)
        end

        def load_data
          @active_sale ||= Spree::ActiveSale.find_by_permalink!(params[:active_sale_id])
          @active_sale_event ||= Spree::ActiveSaleEvent.find(params[:active_sale_event_id])
          @sale_products ||= @active_sale_event.sale_products.page(params[:page]).per(SpreeActiveSale::Config[:admin_active_sale_event_products_per_page])
        end
    end
  end
end
