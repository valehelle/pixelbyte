class AddTimeToPost < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :created_time, :datetime
  end
end
