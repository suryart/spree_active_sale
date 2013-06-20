# coding: UTF-8
require 'spree/core/testing_support/factories'

FactoryGirl.define do
  sequence(:sale_name) { |n| "Active Sale - #{n}" }
  sequence(:event_name) { |n| "Active Sale Event - #{n}" }
  sequence(:start_date) { |n| n.day.ago }
  sequence(:end_date) { |n| n < 1 ? 1.day.from_now : n.days.from_now }

  sequence(:eventable_product) { FactoryGirl.create(:product) }

  sequence :eventable_taxon do |n|
    number = n+Random.rand(50)
    FactoryGirl.create(:taxon) do |taxon|
      taxon.products << FactoryGirl.create_list(:product, number)
    end
    # FactoryGirl.create(:taxon) do |taxon|
      # Array(0..9).sample.times.map do
      #   taxon.products << FactoryGirl.generate(:eventable_product)
      # end
    # end
  end

  # sequence :eventable_taxon do |f|
  #   taxon = FactoryGirl.create(:taxon)
  #   products {
  #     Array(0..9).sample.times.map do
  #       FactoryGirl.create(:product)
  #     end
  #   }
  # end

  trait :inactive do
    is_active false
  end
  
  trait :hidden do
    is_hidden true
  end

  trait :permanent do
    is_permanent true
  end

  trait :product_as_eventable do
    eventable { generate(:eventable_product) }
  end
  
  trait :taxon_as_eventable do
    eventable { generate(:eventable_taxon) }
  end

  factory :active_sale, :class => Spree::ActiveSale do
    
    eventable = FactoryGirl.generate(:eventable_taxon)
    name { generate(:sale_name) }
    start_date { generate(:start_date) }
    end_date { generate(:end_date) }
    eventable_id eventable.id
    eventable_type eventable.class.name

    factory :inactive_sale, :traits => [:inactive]

    # active_sale_with_events will create events data after the sale has been created
    # Usages:
    # FactoryGirl.create(:active_sale_with_events).actice_sale_events.length # 5
    # FactoryGirl.create(:active_sale_with_events, :events_count => 15).actice_sale_events.length # 15
    factory :active_sale_with_events do
      ignore do
        events_count 5
        active true
      end

      after(:create) do |sale, evaluator|
        FactoryGirl.create_list(:active_sale_event, evaluator.events_count, :active_sale => active_sale, :is_active => evaluator.active)
      end

      factory :inactive_sale_with_events, :traits => [:inactive]
    end
  end

  # Default Active Sale Event Factory
  factory :active_sale_event, :class => Spree::ActiveSaleEvent, :aliases => [:active_sale_event_for_taxon] do
    active_sale

    eventable { generate(:eventable_taxon) }

    # attributes
    name { generate(:event_name) }
    start_date
    end_date

    factory :active_sale_event_for_product, :traits => [:product_as_eventable]
    factory :inactive_sale_event, :traits => [:inactive]
    factory :inactive_sale_event_for_taxon, :traits => [:inactive]
    factory :inactive_sale_event_for_product, :traits => [:inactive, :product_as_eventable]

    # associations
    # active_sale_id active_sale.id
    # eventable_id product.id
    # eventable_type product.class.name
  end

  # Active Sale Event Factory for a single Product
  # factory :active_sale_event_for_product, :class => Spree::ActiveSaleEvent do |f|
  #   active_sale_event
  # end

  # Active Sale Event Factory for Taxon(i.e. a group of products)
  # factory :active_sale_event_for_taxon, :class => Spree::ActiveSaleEvent do |f|
  #   active_sale = FactoryGirl.create(:active_sale)

  #   taxon = FactoryGirl.create(:taxon)
  #   1.upto(10).each do |i|
  #     product = FactoryGirl.create(:product)
  #     taxon.products << product unless taxon.products.include? product
  #   end
    
  #   # attributes
  #   name
  #   is_active true
  #   start_date 1.day.ago
  #   end_date 6.days.from_now

  #   # associations
  #   active_sale_id active_sale.id
  #   eventable_id taxon.id
  #   eventable_type taxon.class.to_s
  #   permalink "t/#{taxon.permalink}"
  # end

  # Default InActive Sale Event Factory
  # factory :inactive_sale_event, :class => Spree::ActiveSaleEvent do |f|
  #   active_sale = FactoryGirl.create(:active_sale)
  #   product = FactoryGirl.create(:product)

  #   # attributes
  #   name
  #   is_active false
  #   start_date 1.day.ago
  #   end_date 6.days.from_now

  #   # associations
  #   active_sale_id active_sale.id
  #   eventable_id product.id
  #   eventable_type product.class.to_s
  #   permalink "products/#{product.permalink}"
  # end

  # InActive Sale Event Factory for a single Product
  # factory :inactive_sale_event_for_product, :class => Spree::ActiveSaleEvent do |f|
  #   inactive_sale_event
  # end

  # InActive Sale Event Factory for Taxon(i.e. a group of products)
  # factory :inactive_sale_event_for_taxon, :class => Spree::ActiveSaleEvent do |f|
  #   active_sale = FactoryGirl.create(:active_sale)

  #   taxon = FactoryGirl.create(:taxon)
  #   1.upto(10).each do |i|
  #     product = FactoryGirl.create(:product)
  #     taxon.products << product unless taxon.products.include? product
  #   end
    
  #   # attributes
  #   name
  #   is_active false
  #   start_date 1.day.ago
  #   end_date 6.days.from_now

  #   # associations
  #   active_sale_id active_sale.id
  #   eventable_id taxon.id
  #   eventable_type taxon.class.to_s
  #   permalink "t/#{taxon.permalink}"
  # end
end