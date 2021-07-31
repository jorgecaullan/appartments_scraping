class CreateFilters < ActiveRecord::Migration[5.2]
  def change
    create_table :filters do |t|
      t.string :url
      t.string :commune
      t.string :bedrooms_range
      t.string :bathrooms_range
      t.string :price_range
      t.string :useful_surface_range
      t.boolean :parking

      t.timestamps
    end
  end
end
