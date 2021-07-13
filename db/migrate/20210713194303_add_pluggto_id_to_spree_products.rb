class AddPluggtoIdToSpreeProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :spree_products, :pluggto_id, :string
  end
end
