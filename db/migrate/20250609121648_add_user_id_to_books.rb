class AddUserIdToBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :books, :user_id, :integer
  end
end
