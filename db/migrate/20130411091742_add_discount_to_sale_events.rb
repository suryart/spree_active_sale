class AddDiscountToSaleEvents < ActiveRecord::Migration
  def change
    add_column :spree_sale_events, :discount, :integer
  end
end
