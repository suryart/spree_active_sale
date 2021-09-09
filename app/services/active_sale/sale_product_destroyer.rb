module ActiveSale
  class SaleProductDestroyer < BaseService
    def call
      Spree::SaleProduct.transaction do
        Spree::ProductPromotionRule.find_by(
          product_id: sale_product.product_id,
          promotion_rule_id: sale_product.active_sale_event.promotion_rules.first.id,
        ).destroy

        sale_product.destroy
      end
    end

    private

    def sale_product
      attributes.fetch(:sale_product)
    end
  end
end
