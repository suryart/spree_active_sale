module Spree
  class SaleTaxon < ActiveRecord::Base
    belongs_to :active_sale_event, :class_name => 'Spree::ActiveSaleEvent'
    belongs_to :taxon, :class_name => 'Spree::Taxon'
    attr_accessor :active_sale_event_id, :taxon_id, :position
  end
end
