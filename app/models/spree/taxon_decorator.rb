module Spree
  module TaxonDecorator
    def self.prepended(base)
      base.has_many :sale_taxons
      base.has_many :active_sale_events, :through => :sale_taxons
    end

    # taxon.live_active_sale_events gets all sale events which is live and active
    def live_active_sale_events
      Spree::ActiveSaleEvent.joins(:taxons).where({ :spree_taxons => {:id => self.id} }).merge(Spree::ActiveSaleEvent.available)
    end

    # if there is at least one sale event which is live and active.
    def live?
      !self.live_active_sale_events.blank?
    end
  end
end

Spree::Taxon.prepend(Spree::TaxonDecorator)
