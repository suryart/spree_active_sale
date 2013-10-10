module Spree
  module ActiveSaleEventsHelper
    
    def sale_event_timer(event = nil, layout = nil)
      return I18n.t('spree.active_sale.event.can_not_be_nil') if event.nil? || !(event.kind_of? Spree::ActiveSaleEvent)
      layout ||= '{dn} DAYS {hnn}{sep}{mnn}{sep}{snn}'
      content_tag(:span, I18n.t('spree.active_sale.event.ending_message'), :class => 'sale_event_message') + " " + content_tag(:span, event.end_date.strftime('%Y-%m-%dT%H:%M:%S'), :data => { :timer => event.end_date.strftime('%Y-%m-%dT%H:%M:%S'), :layout => layout }, :class => 'sale_event_message_timer')
    end

    def method_missing(method_name, *args, &block)
      if image_style = image_style_from_method_name_for_sale(method_name)
        define_sale_image_method(image_style)
        self.send(method_name, *args)
      else
        super
      end
    end

    def sale_image_available?(sale_event)
      !sale_event.sale_images.empty? || sale_event.eventable_image_available?
    end

    private

    # Returns style of image or nil
    def image_style_from_method_name_for_sale(method_name)
      if style = method_name.to_s.sub(/_event_image$/, '')
        possible_styles = Spree::SaleImage.attachment_definitions[:attachment][:styles]
        style if style.in? possible_styles.with_indifferent_access
      end
    end

    def define_sale_image_method(style)
      self.class.send :define_method, "#{style}_event_image" do |sale_event, *options|
        options = options.first || {}
        if sale_event.sale_images.empty?
          sale_event.single_product_sale? ? get_product_image(sale_event) : (image_tag "noimage/#{style}.png", options)
        else
          image = sale_event.sale_images.first
          options.reverse_merge! :alt => image.alt.blank? ? sale_event.name : image.alt
          image_tag image.attachment.url(style), options
        end
      end
    end

    def get_product_image(sale_event)
      if sale_event.products.empty?
        image_tag "noimage/#{style}.png", options
      else
        product = sale_event.products.first
        send("#{style}_image", product)
      end
    end
  end
end
