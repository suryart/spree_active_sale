module Spree
  module BaseHelperDecorator
    def self.prepended(base)
      base.include Spree::ActiveSalesHelper
    end
  end
end

Spree::BaseHelper.prepend(Spree::BaseHelperDecorator)
