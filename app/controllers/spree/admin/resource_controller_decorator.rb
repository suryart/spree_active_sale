module Spree
  module Admin
    module ResourceControllerDecorator

    end
  end
end


Spree::Admin::ResourceController.prepend(Spree::Admin::ResourceControllerDecorator)