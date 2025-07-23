class AddDeletedToUsersAndBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :deleted, :boolean, default: false
    add_column :books, :deleted, :boolean, default: false
  end
end
