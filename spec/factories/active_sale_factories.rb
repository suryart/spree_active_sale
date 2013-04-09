# coding: UTF-8
require 'spree/core/testing_support/factories'

FactoryGirl.define do
  factory :active_sale, :class => Spree::ActiveSale do |f|
    name "Dummy Sale"
  end

  factory :active_sale_event, :class => Spree::ActiveSaleEvent do |f|
    active_sale
    name "Dummy Sale Event"
    permalink "dummy-sale-event"
    is_permanent true
    is_active true
    start_date 1.day.ago
    end_date 1.day.from_now
  end

  sequence :name do |n|
    "Dummy Sale Event - #{n}"
  end

  sequence :eventable_taxon do |f|
    taxon = FactoryGirl.create(:taxon)
    products {
      Array(0..9).sample.times.map do
        FactoryGirl.create(:product)
      end
    }
  end

  # Default Active Sale Event Factory
  factory :active_sale_event, :class => Spree::ActiveSaleEvent do |f|
    active_sale = FactoryGirl.create(:active_sale)
    product = FactoryGirl.create(:product)

    # attributes
    name
    is_active true
    start_date 1.day.ago
    end_date 6.days.from_now

    # associations
    active_sale_id active_sale.id
    eventable_id product.id
    eventable_type product.class.to_s
    permalink "products/#{product.permalink}"
  end

  # Active Sale Event Factory for a single Product
  factory :active_sale_event_for_product, :class => Spree::ActiveSaleEvent do |f|
    active_sale_event
  end

  # Active Sale Event Factory for Taxon(i.e. a group of products)
  factory :active_sale_event_for_taxon, :class => Spree::ActiveSaleEvent do |f|
    active_sale = FactoryGirl.create(:active_sale)

    taxon = FactoryGirl.create(:taxon)
    1.upto(10).each do |i|
      product = FactoryGirl.create(:product)
      taxon.products << product unless taxon.products.include? product
    end
    
    # attributes
    name
    is_active true
    start_date 1.day.ago
    end_date 6.days.from_now

    # associations
    active_sale_id active_sale.id
    eventable_id taxon.id
    eventable_type taxon.class.to_s
    permalink "t/#{taxon.permalink}"
  end

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
