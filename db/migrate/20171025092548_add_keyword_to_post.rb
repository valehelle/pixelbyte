class AddKeywordToPost < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :keyword, :string
  end
end
