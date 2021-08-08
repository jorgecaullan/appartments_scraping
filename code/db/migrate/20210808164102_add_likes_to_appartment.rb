class AddLikesToAppartment < ActiveRecord::Migration[5.2]
  def change
    add_column :appartments, :like_jorge, :boolean
    add_column :appartments, :like_mayra, :boolean
  end
end
