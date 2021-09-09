class AddPromotionToActiveSaleEvent < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_active_sale_events, :promotion_id, :integer, index: true
  end
end
