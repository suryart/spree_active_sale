Spree::Taxon.class_eval do
  include Spree::ActiveSalesHelper
  
  has_many :active_sale_events, :as => :eventable

  # taxon.live_active_sale_event gets first active sale event which is live and active
  def live_active_sale_event
    get_sale_event(self)
  end

  # if there is at least one active sale event which is live and active.
  def live?
    !self.live_active_sale_event.nil?
  end

  def image_available?
    icon?
  end

  def image
    icon
  end
end