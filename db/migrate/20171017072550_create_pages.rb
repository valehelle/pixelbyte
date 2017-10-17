class CreatePages < ActiveRecord::Migration[5.1]
  def change
    create_table :pages do |t|
      t.string :page_id
      t.string :access_token
      t.string :name
      t.boolean :is_admin
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
