# More on Spree's preference configuration - http://guides.spreecommerce.com/preferences.html#site_wide_preferences
module Spree
  class ActiveSaleConfiguration < Preferences::Configuration
    preference :paginate_sale_events_for_admin?, :boolean, :default => false
    preference :paginate_sales_for_admin?, :boolean, :default => false
    preference :paginate_sale_events_for_user?, :boolean, :default => false
    preference :paginate_sales_for_user?, :boolean, :default => false
    preference :name_with_event_position?, :boolean, :default => false
    preference :admin_active_sales_per_page, :integer, :default => 25
    preference :active_sales_per_page, :integer, :default => 25
    preference :admin_active_sale_events_per_page, :integer, :default => 25
    preference :active_sale_events_per_page, :integer, :default => 25
  end
end
