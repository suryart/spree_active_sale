# coding: UTF-8
require 'spree/core/testing_support/factories'

FactoryGirl.define do
  # Default InActive Sale Event Factory
  factory :inactive_sale_event, :class => Spree::ActiveSaleEvent do |f|
    active_sale = FactoryGirl.create(:active_sale)
    product = FactoryGirl.create(:product)

    # attributes
    name
    is_active false
    start_date 1.day.ago
    end_date 6.days.from_now

    # associations
    active_sale_id active_sale.id
    eventable_id product.id
    eventable_type product.class.to_s
    permalink "products/#{product.permalink}"
  end

  # InActive Sale Event Factory for a single Product
  factory :inactive_sale_event_for_product, :class => Spree::ActiveSaleEvent do |f|
    inactive_sale_event
  end

  # InActive Sale Event Factory for Taxon(i.e. a group of products)
  factory :inactive_sale_event_for_taxon, :class => Spree::ActiveSaleEvent do |f|
    active_sale = FactoryGirl.create(:active_sale)

    taxon = FactoryGirl.create(:taxon)
    1.upto(10).each do |i|
      product = FactoryGirl.create(:product)
      taxon.products << product unless taxon.products.include? product
    end
    
    # attributes
    name
    is_active false
    start_date 1.day.ago
    end_date 6.days.from_now

    # associations
    active_sale_id active_sale.id
    eventable_id taxon.id
    eventable_type taxon.class.to_s
    permalink "t/#{taxon.permalink}"
  end
end