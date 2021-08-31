module Spree
  module PromotionCategoryDecorator
    def self.prepended(base)
      def base.active_sale
        ::Spree::PromotionCategory.find_or_create_by(name: "Active Sale", code: 'active sale')
      end
    end
  end
end

Spree::PromotionCategory.prepend(Spree::PromotionCategoryDecorator)
