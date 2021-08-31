class DestroyPromotion < ApplicationService
  def call
    active_sale_event.promotion_rules.last.product_promotion_rules.destroy_all
    active_sale_event.promotion_rules.destroy_all
    active_sale_event.promotion_actions.last.calculator.destroy
    active_sale_event.promotion_actions.destroy_all
  end

  private

  def active_sale_event
    attributes.fetch(:active_sale_event)
  end
end
