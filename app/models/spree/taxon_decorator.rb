Spree::Taxon.class_eval do
  has_many :active_sale_events, :as => :eventable

  # if there is at least one active sale event which is live and active.
  def live?
    !self.active_sale_events.detect{ |event| event.live_and_active? }.nil?
  end

  def image_available?
    icon?
  end

  def image
    icon
  end
end