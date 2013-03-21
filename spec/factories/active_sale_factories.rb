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

  factory :active_sales, :class => Spree::ActiveSale do |f|
    f.sequence(:name) { |n| "Dummy Sale - #{n}"}
  end

  factory :active_sale_events, :class => Spree::ActiveSaleEvent do |f|
    f.sequence(:create_product) { |n| Product.find(n) } # Need a list of products here to have factory working
    f.sequence(:name) { |n| "Dummy Sale event - #{n}" }
    f.sequence(:eventable) { |n| Spree::Product.find(n) }
    f.sequence(:permalink) { |n| eventable.permalink }
    f.association :active_sale, :factory => Spree::ActiveSale
  end
end
