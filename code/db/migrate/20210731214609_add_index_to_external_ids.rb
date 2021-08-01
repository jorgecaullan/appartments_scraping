class AddIndexToExternalIds < ActiveRecord::Migration[5.2]
  def change
    add_index :appartments, :external_id, unique: true
  end
end
