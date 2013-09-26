class ChangeTypeOfDiscountFromIntegerToDecimal < ActiveRecord::Migration
  def up
    change_column :spree_sale_events, :discount, :decimal, :scale => 6, :precision => 8, :default => 0.0
  end

  def down
    change_column :spree_sale_events, :discount, :integer
  end
end
