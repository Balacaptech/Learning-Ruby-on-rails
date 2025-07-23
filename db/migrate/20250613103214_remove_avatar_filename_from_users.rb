class RemoveAvatarFilenameFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :avatar_filename, :string
  end
end
