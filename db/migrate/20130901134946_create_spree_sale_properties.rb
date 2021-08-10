class CreateSpreeSaleProperties < ActiveRecord::Migration[6.1]
  def change
    create_table :spree_sale_properties do |t|
      t.integer :active_sale_event_id
      t.integer :property_id
      t.integer :position, :default => 0

      t.timestamps
    end
  end
end
