class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :post_id
      t.boolean :is_private_message
      t.string :private_message_content
      t.boolean :is_reply
      t.string :reply_content
      t.string :content
      t.references :page, foreign_key: true

      t.timestamps
    end
  end
end
