class CreateCars < ActiveRecord::Migration[8.0]
  def change
    create_table :cars do |t|
      t.string :name
      t.string :brand
      t.string :price
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
