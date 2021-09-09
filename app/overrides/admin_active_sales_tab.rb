Deface::Override.new( name: "active_sale_tab",
                      virtual_path: "spree/admin/shared/sub_menu/_promotion",
                      insert_bottom: '[data-hook="admin_promotion_sub_tabs"]',
                      # text: "<ul class='nav nav-sidebar border-bottom'> <%= tab Spree.t('active_sale.name'), url: spree.admin_active_sales_path  %> </ul>"
                      text: "<%= tab(:active_sales, label: Spree.t('active_sale.name') ) %>"
                    )
