module SpreeActiveSale
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_active_sale'

    config.autoload_paths += %W(#{config.root}/lib)

    initializer "spree_active_sale.environment", :before => "spree.environment" do |app|
      Spree::ActiveSaleConfig = Spree::ActiveSaleConfiguration.new
      %w(ActionController::Base Spree::BaseController).each { |controller| 
        controller.constantize.send(:helper, Spree::ActiveSaleEventsHelper)
      }
    end

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end