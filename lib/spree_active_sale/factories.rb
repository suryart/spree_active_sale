# coding: UTF-8
# Example adding this to your spec_helper will load these Factories for use:
# require 'spree_active_sale/factories'
FactoryGirl.define do
  trait :inactive do
    is_active false
  end
  
  trait :hidden do
    is_hidden true
  end

  trait :permanent do
    is_permanent true
  end

  factory :active_sale, :class => Spree::ActiveSale do
    sequence(:name) { |n| "Active Sale ##{n} - #{Kernel.rand(9999)}" }

    # active_sale_with_events will create events data after the sale has been created
    # Usages:
    # FactoryGirl.create(:active_sale_with_events).actice_sale_events.length # 5
    # FactoryGirl.create(:active_sale_with_events, :active => false) # for inactive sale events
    # FactoryGirl.create(:active_sale_with_events, :events_count => 15).actice_sale_events.length # 15
    factory :active_sale_with_events do
      ignore do
        events_count 5
        active true
        permanent false
        hidden false
        single_product_sale false
      end

      after(:create) do |sale, evaluator|
        FactoryGirl.create_list(:active_sale_event, evaluator.events_count, :active_sale => sale, :is_active => evaluator.active, :is_hidden => hidden, :is_permanent => permanent, :single_product_sale => single_product_sale)
      end

      factory :inactive_sale_with_events, :traits => [:inactive]
      factory :hidden_active_sale_with_events, :traits => [:hidden]
      factory :permanent_active_sale_with_events, :traits => [:permanent]
    end
  end

  # Default Active Sale Event Factory
  factory :active_sale_event, :class => Spree::ActiveSaleEvent, :aliases => [:event] do
    active_sale

    # attributes
    sequence(:name) { |n| "Active Sale Event ##{n} - #{Kernel.rand(9999)}" }
    description { Faker::Lorem.paragraphs(1 + Kernel.rand(5)).join("\n") }
    sequence(:start_date) { |n| n < 1 ? 1.day.ago : n.days.ago }
    sequence(:end_date) { |n| n < 1 ? 1.day.from_now : n.days.from_now }

    factory :active_sale_event_with_products do
      ignore do
        products_count 5
        taxons_count 2
      end

      after(:create) do |event, evaluator|
        FactoryGirl.create_list(:sale_product, evaluator.products_count, :active_sale_event => event)
      end

      factory :inactive_sale_event_with_products, :traits => [:inactive]
      factory :hidden_active_sale_event_with_products, :traits => [:hidden]
      factory :permanent_active_sale_event_with_products, :traits => [:permanent]

      factory :active_sale_event_with_taxon_and_products do
        after(:create) do |event, evaluator|
          FactoryGirl.create_list(:sale_taxon, evaluator.taxons_count, :active_sale_event => event)
        end
      end
    end

    factory :inactive_sale_event, :traits => [:inactive]
  end

  factory :sale_product, :class => Spree::SaleProduct do
    active_sale_event { FactoryGirl.create(:active_sale_event) }
    product { FactoryGirl.create(:product) }
  end

  factory :sale_taxon, :class => Spree::SaleTaxon do
    active_sale_event { FactoryGirl.create(:active_sale_event) }
    taxon { FactoryGirl.create(:taxon) }
  end
end