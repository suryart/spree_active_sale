class UpdatePromotion < ApplicationService
  def call
    active_sale_event.promotion.update(
      starts_at: active_sale_event.start_date,
      expires_at: active_sale_event.end_date,
      description: active_sale_event.description
    )

    active_sale_event.promotion_actions.first.calculator.update(preferences: { percent: active_sale_event.discount })
  end

  private

  def active_sale_event
    attributes.fetch(:active_sale_event)
  end
end
