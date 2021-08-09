class OldActiveSale < ActiveRecord::Base
  self.table_name = "spree_active_sales"
end

class RevertActiveSaleSti < ActiveRecord::Migration[6.1]
  def up
    # Required to get new data saved in old format!
    # Saving data to old structure by running steps below:
    remove_index :spree_sale_events, :name => :index_active_sale_on_parent_id
    remove_index :spree_sale_events, :name => :index_active_sale_on_active_sale_id
    remove_index :spree_sale_events, :name => :index_active_sale_on_permalink

    unless table_exists?(:spree_active_sales)
      create_table :spree_active_sales do |t|
        t.string :name
        t.string :permalink
        t.integer :position
        t.datetime :deleted_at, :default => nil

        t.timestamps
      end
      add_column :spree_active_sales, :type, :string, :default => "Spree::ActiveSale"
      revert_changes
      remove_column :spree_active_sales, :type
    end

    remove_column :spree_sale_events, :rgt
    remove_column :spree_sale_events, :lft
    remove_column :spree_sale_events, :parent_id
    remove_column :spree_sale_events, :type
    rename_table :spree_sale_events, :spree_active_sale_events
    remove_column :spree_active_sale_events, :permalink
    add_column :spree_active_sale_events, :deleted_at, :datetime, :default => nil
    add_column :spree_active_sale_events, :shipping_category_id, :integer
  end

  def update_changes
    OldActiveSale.where(:type => nil).each{ |a| a.update_attributes(:type => "Spree::ActiveSale") }
    Spree::SaleEvent.where(:type => nil).each{ |sale| sale.update_attributes(:type => "Spree::ActiveSaleEvent") }
    OldActiveSale.all.each{ |as|
      sale = Spree::SaleEvent.find_or_create_by_name_and_active_sale_id_and_type(as.name, nil, "Spree::ActiveSale")
      as.active_sale_events.each{ |event|
        event.update_attributes(:active_sale_id => sale.id)
      }
    }
  end

  def revert_changes
    Spree::SaleEvent.where(:type => "Spree::ActiveSale").update_all(:type => nil)
    Spree::SaleEvent.where(:active_sale_id => nil).each{ |as|
      sale = OldActiveSale.find_or_create_by_name(as.name)
      Spree::ActiveSaleEvent.where(:active_sale_id => as.id).update_all(:active_sale_id => sale.id)
    }
    Spree::SaleEvent.where(:active_sale_id => nil).destroy_all
  end

  def down
    # New migration starts here:
    rename_table :spree_active_sale_events, :spree_sale_events
    add_column :spree_sale_events, :type, :string
    add_column :spree_sale_events, :parent_id, :integer
    add_column :spree_sale_events, :lft, :integer
    add_column :spree_sale_events, :rgt, :integer

    # Required to have old data backed up!
    # Saving data to new structure by running steps below:
    if table_exists?(:spree_active_sales)
      add_column :spree_active_sales, :type, :string, :default => "Spree::ActiveSale"
      update_changes
      drop_table :spree_active_sales
    end

    # Index for search
    add_index :spree_sale_events, [:parent_id], :name => 'index_active_sale_on_parent_id'
    add_index :spree_sale_events, [:active_sale_id], :name => 'index_active_sale_on_active_sale_id'
    add_index :spree_sale_events, [:permalink], :name => 'index_active_sale_on_permalink'
  end
end
