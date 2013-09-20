Deface::Override.new( :name => "active_sale_tab",
                      :virtual_path => "spree/layouts/admin",
                      :insert_bottom => "[data-hook='admin_tabs'], #admin_tabs[data-hook]",
                      :text => "<%= tab :active_sales, :active_sale_events, :sale_images, :sale_products, :icon => 'icon-th-list' %>")