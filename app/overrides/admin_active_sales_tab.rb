Deface::Override.new(
            name: "active_sale_tab",
            virtual_path: "spree/admin/shared/_menu",
            insert_bottom: "[data-hook='admin_tabs'], #admin_tabs[data-hook]",
            text: "<%= tab :active_sales, :icon => 'icon-th-list' %>"
)
