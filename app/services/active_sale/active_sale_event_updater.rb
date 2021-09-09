module ActiveSale
  class ActiveSaleEventUpdater < BaseService
    def call
      Spree::ActiveSaleEvent.transaction do
        if active_sale_event.update(permitted_resource_params)
          active_sale_event.promotion.update(
            starts_at: active_sale_event.start_date,
            expires_at: active_sale_event.end_date,
            description: active_sale_event.description,
            name: active_sale_event.name
          )

          active_sale_event.promotion_actions.first.calculator.update(preferences: { percent: active_sale_event.discount })
        else
          context.success = false
          context.errors = active_sale_event.errors.messages
        end

        context
      end
    end

    private

    def active_sale_event
      @active_sale_event ||= attributes.fetch(:active_sale_event)
    end

    def permitted_resource_params
      attributes.fetch(:params)
    end
  end
end
