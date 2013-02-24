FactoryGirl.define do
  factory :active_sale do |f|
    :name => "Levi's Stross"
  end

  factory :active_sales do |f|
    f.sequence(:name) { |n| "Sale - #{n}"}
  end

  factory :active_sale_with_events do |f|
    f.sequence(:name) { |n| "Sale - #{n}" }
  end
end