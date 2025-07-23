class RemovePriceFromCars < ActiveRecord::Migration[8.0]
  def change
    remove_column :cars, :price, :decimal
  end
end
