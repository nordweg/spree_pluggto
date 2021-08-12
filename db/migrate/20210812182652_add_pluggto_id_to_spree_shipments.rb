class AddPluggtoIdToSpreeShipments < ActiveRecord::Migration[5.1]
  def change
    add_column :spree_shipments, :pluggto_id, :string
  end
end
