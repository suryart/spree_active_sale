class CreateSpreeSaleTaxons < ActiveRecord::Migration[6.1]
  def change
    create_table :spree_sale_taxons do |t|
      t.integer :taxon_id
      t.integer :active_sale_event_id
      t.integer :position, :default => 0

      t.timestamps
    end
  end
end
