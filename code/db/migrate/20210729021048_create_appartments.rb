class CreateAppartments < ActiveRecord::Migration[5.2]
  def change
    create_table :appartments do |t|
      t.references :filter, foreign_key: true
      t.string :external_id
      t.string :url
      t.integer :cost
      t.integer :common_expenses
      t.integer :bedrooms
      t.integer :bathrooms
      t.integer :floor
      t.string :orientation
      t.integer :useful_surface
      t.integer :total_surface
      t.float :latitude
      t.float :longitude
      t.date :published
      t.boolean :sold_out
      t.date :sold_date
      t.boolean :rejected
      t.string :reject_reason

      t.timestamps
    end
  end
end
