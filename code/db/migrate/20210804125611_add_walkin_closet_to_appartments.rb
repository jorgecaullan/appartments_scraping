class AddWalkinClosetToAppartments < ActiveRecord::Migration[5.2]
  def change
    add_column :appartments, :walk_in_closet, :boolean
  end
end
