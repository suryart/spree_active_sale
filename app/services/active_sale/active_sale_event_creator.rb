module ActiveSale
  class ActiveSaleEventCreator < BaseService
    def call
      Spree::ActiveSaleEvent.transaction do
        context.active_sale_event = Spree::ActiveSaleEvent.new(permitted_resource_params)
        promotion = Spree::Promotion.create!(
          name: name,
          description: description.first(255),
          starts_at: start_date,
          expires_at: end_date
        )
        context.active_sale_event.promotion_id = promotion.id

        if context.active_sale_event.save
          proption_rule = Spree::PromotionRule.create!(
            promotion: context.active_sale_event.promotion,
            type: "Spree::Promotion::Rules::Product",
            preferences: {:match_policy=>"any"}
          )
          promotion_action = Spree::PromotionAction.create!(
            promotion: context.active_sale_event.promotion,
            type: "Spree::Promotion::Actions::CreateItemAdjustments",
            preferences: nil
          )

          promotion_action.calculator.update(
            preferences: { percent: context.active_sale_event.discount }
          )
        else
          context.success = false
          context.errors = context.active_sale_event.errors.messages
        end

        context
      end
    end

    private

    def permitted_resource_params
      attributes.fetch(:params)
    end

    def name
      permitted_resource_params["name"]
    end

    def start_date
      permitted_resource_params["start_date"]
    end

    def end_date
      permitted_resource_params["end_date"]
    end

    def description
      permitted_resource_params["description"]
    end
  end
end
