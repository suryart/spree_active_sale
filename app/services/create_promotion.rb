class CreatePromotion < ApplicationService
  def call
    active_sale_event.promotion.update(
      starts_at: active_sale_event.start_date,
      expires_at: active_sale_event.end_date,
      description: active_sale_event.description
    )
    proption_rule = Spree::PromotionRule.create(
      promotion: active_sale_event.promotion,
      type: "Spree::Promotion::Rules::Product",
      preferences: {:match_policy=>"all"}
    )
    promotion_action = Spree::PromotionAction.create(
      promotion: active_sale_event.promotion,
      type: "Spree::Promotion::Actions::CreateItemAdjustments",
      preferences: nil
    )

    Spree::Calculator.create(
      type: "Spree::Calculator::PercentOnLineItem",
      calculable_type: "Spree::PromotionAction",
      calculable_id: promotion_action.id,
      preferences: { percent: active_sale_event.discount }
    )
  end

  private

  def active_sale_event
    attributes.fetch(:active_sale_event)
  end
end
