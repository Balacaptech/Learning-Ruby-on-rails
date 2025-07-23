class AddAvatarFilenameToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :avatar_filename, :string
  end
end
