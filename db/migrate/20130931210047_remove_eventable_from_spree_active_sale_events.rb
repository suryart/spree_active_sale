class RemoveEventableFromSpreeActiveSaleEvents < ActiveRecord::Migration[6.1]
  def up
    add_column :spree_active_sale_events, :single_product_sale, :boolean, :default => false

    Spree::ActiveSaleEvent.where(:eventable_type => 'Spree::Product').each do |sale|
      sale.update_attribute(:single_product_sale, true)
      sale.sale_products.find_or_create_by_product_id(sale.eventable_id)
    end

    Spree::ActiveSaleEvent.where(:eventable_type => 'Spree::Taxon').each do |sale|
      taxon = Spree::Taxon.where(:id => sale.eventable_id).first
      unless taxon.blank?
        sale.sale_taxons.find_or_create_by_taxon_id(taxon.id)
        taxon.products.active.each do |product|
          sale.sale_products.find_or_create_by_product_id(sale.eventable_id)
        end
      end
    end

    remove_column :spree_active_sale_events, :eventable_id
    remove_column :spree_active_sale_events, :eventable_type
  end

  def down
    add_column :spree_active_sale_events, :eventable_id, :integer
    add_column :spree_active_sale_events, :eventable_type, :string

    Spree::ActiveSaleEvent.where(:single_product_sale => false).each do |se|
      unless se.sale_products.first.blank?
        se.update_attributes(:eventable_id => se.sale_products.first.product_id, :eventable_type => 'Spree::Product', :single_product_sale => false)
      end
    end

    Spree::ActiveSaleEvent.where(:single_product_sale => true).each do |se|
      unless se.sale_taxons.first.blank?
        se.update_attributes(:eventable_id => se.sale_taxons.first.taxon_id, :eventable_type => 'Spree::Taxon')
      end
      se.sale_products = []
      se.save!
    end
  end
end
