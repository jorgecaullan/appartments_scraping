class CreateVisitComments < ActiveRecord::Migration[5.2]
  def change
    create_table :visit_comments do |t|
      t.references :appartment, foreign_key: true
      t.datetime :visit_date_time
      t.string :contact
      t.string :address
      t.string :extra_comments
      t.integer :elevator_status
      t.integer :balcony
      t.integer :view
      t.integer :water_key_status
      t.integer :water_pressure

      t.timestamps
    end
  end
end
