class AddSyncWithPluggtoToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :spree_products, :sync_with_pluggto, :boolean, default: false
  end
end
