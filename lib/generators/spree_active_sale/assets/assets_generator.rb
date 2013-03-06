module SpreeActiveSale
  module Generators
    class AssetsGenerator < Rails::Generators::Base

      source_root File.expand_path('../../templates', __FILE__)

      desc 'Copies the assets from spree_active_sale plugin to the applciation\'s assets folder.'

      def copy_locale
        directory assets_source_path, assets_destination_path
        directory js_source_path, js_destination_path
      end

      def show_readme
        readme 'README.md' if behavior == :invoke
      end

      private

      def assets_source_path
        '../../../../vendor/assets/stylesheets/'
      end
      
      def assets_destination_path
        'app/assets/stylesheets/'
      end
      
      def js_source_path
        '../../../../vendor/assets/javascripts/'
      end
      
      def js_destination_path
        'app/assets/javascripts/'
      end
    end
  end
end
