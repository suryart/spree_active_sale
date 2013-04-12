class AddDiscountToActiveSaleEvent < ActiveRecord::Migration
  def change
    add_column :spree_active_sale_events, :discount, :integer
  end
end
