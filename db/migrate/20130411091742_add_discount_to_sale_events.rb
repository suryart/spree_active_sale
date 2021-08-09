class AddDiscountToSaleEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_sale_events, :discount, :integer
  end
end
