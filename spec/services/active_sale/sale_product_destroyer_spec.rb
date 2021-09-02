require 'spec_helper'

RSpec.describe ActiveSale::SaleProductDestroyer do
  it "creates promotion from acative sale event" do
    active_sale_event = create(:active_sale_event)
    promotion = active_sale_event.promotion
    product = create(:product)
    promotion_rule = create(:promotion_rules_product, promotion: promotion)
    sale_product = create(:sale_product, active_sale_event: active_sale_event, product: product)
    product_promotion_rule = create(:product_promotion_rule, promotion_rule: promotion_rule, product: product)
    promotion.reload

    ActiveSale::SaleProductDestroyer.call(sale_product: sale_product)

    expect(promotion_rule.product_promotion_rules).to be_blank
    expect(Spree::SaleProduct.exists?(sale_product.id)).to eq(false)
  end
end
