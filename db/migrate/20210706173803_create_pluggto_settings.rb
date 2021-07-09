class CreatePluggtoSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :pluggto_settings do |t|
      t.column :client_id, :string
      t.column :client_secret, :string
      t.column :username, :string
      t.column :password, :string
      t.column :access_token, :string
      t.column :refresh_token, :string
      t.column :token_expires_at, :datetime

      t.timestamps
    end
  end
end
