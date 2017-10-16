class AddOmniauthtokenToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :access_token, :string
    add_column :users, :token_expiry_at, :integer
  end
end
