# coding: UTF-8
# Example adding this to your spec_helper will load these Factories for use:
# require 'spree_active_sale/factories'
FactoryGirl.define do
  sequence(:sale_name) { |n| "Active Sale - #{n}" }
  
  sequence(:event_name) { |n| "Active Sale Event - #{n}" }
  sequence(:start_date) { |n| n.day.ago }
  sequence(:end_date) { |n| n < 1 ? 1.day.from_now : n.days.from_now }

  sequence(:eventable_product) { FactoryGirl.create(:product, :available_on => 1.day.ago) }

  sequence :eventable_taxon do |n|
    number = n+Random.rand(50)
    FactoryGirl.create(:taxon) do |taxon|
      taxon.products << FactoryGirl.create_list(:product, number)
    end
  end

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
        FactoryGirl.create_list(:active_sale_event, evaluator.events_count, :active_sale => sale, :is_active => evaluator.active, :parent_id => sale.root.id)
      end

      factory :inactive_sale_with_events, :traits => [:inactive]
    end
  end

  # Default Active Sale Event Factory
  factory :active_sale_event, :class => Spree::ActiveSaleEvent, :aliases => [:active_sale_event_for_taxon] do
    active_sale

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
end