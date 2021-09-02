require 'spec_helper'

RSpec.describe ActiveSale::SaleProductCreator do
  it "creates sale product from acative sale event" do
    promotion = create( :promotion, description: 'promotion description')
    promotion_rule = create(:promotion_rules_product, promotion: promotion)
    product = create(:product)
    active_sale_event = create(
      :active_sale_event,
      promotion: promotion,
      discount: 30,
      description: 'bar',
      start_date: DateTime.now,
      end_date: DateTime.now.next_week
    )

    result = ActiveSale::SaleProductCreator.call(
      active_sale_event: active_sale_event.reload,
      product_id: product.id
    )

    expect(result.sale_product).to have_attributes(
      active_sale_event_id: active_sale_event.id,
      product_id: product.id
    )

    expect(promotion_rule.reload.product_promotion_rules.first).to have_attributes(
      product_id: product.id,
      promotion_rule_id: active_sale_event.promotion_rules.first.id
    )
  end
end
