# coding: UTF-8
require 'spec_helper'

describe Spree::Product do
  context 'in ActiveSaleEvent' do
    let(:product) { create :product }
    let(:taxon_parent) { create :taxon }
    let(:active_sale_event) { build :active_sale_event }

    context 'included using taxon' do
      before do
        active_sale_event.eventable = taxon_parent
        active_sale_event.save
      end

      it "it should be live? if they're related with the same taxon" do
        product.taxons = [taxon_parent]
        product.live?.should be_true
      end

      it "it should be live? if product's taxon is descendant of ActiveSaleEvent's taxon" do
        taxon_b = create(:taxon, :parent => taxon_parent)
        product.taxons = [taxon_b]
        product.live?.should be_true
      end
    end
  end
end
