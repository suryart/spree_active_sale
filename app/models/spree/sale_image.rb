module Spree
  class SaleImage < Asset
    include Configuration::ActiveStorage
    include Rails.application.routes.url_helpers

    def mobile_styles
      results = {}
      self.class.mobile_styles.map do |key, size|
        return unless size

        results[key] = style(key)
      end

      results
    end

    def styles
      results = {}

      self.class.styles.map do |key, size|
        return unless size

        results[key] = style(key)
      end

      results
    end

    def style(name)
      size = self.class.styles[name]
      return unless size

      width, height = image_size = size.split('x').map(&:to_i)

      {
        url: url_for(attachment.variant(resize_and_pad: image_size)),
        size: size,
        width: width,
        height: height
      }
    end
  end
end
