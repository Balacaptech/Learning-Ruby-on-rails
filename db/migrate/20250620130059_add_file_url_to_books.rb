class AddFileUrlToBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :books, :file_url, :string
  end
end
