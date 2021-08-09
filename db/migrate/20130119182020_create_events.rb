class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :spree_active_sale_events do |t|
      t.string :name
      t.text :description
      t.string :permalink
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :is_active, default: true
      t.boolean :is_hidden, default: false
      t.boolean :is_permanent, default: false
      t.integer :eventable_id
      t.string :eventable_type
      t.integer :active_sale_id

      t.timestamps
    end
  end
end
