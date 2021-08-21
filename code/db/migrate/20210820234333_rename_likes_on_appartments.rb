class RenameLikesOnAppartments < ActiveRecord::Migration[5.2]
  def change
    rename_column :appartments, :like_jorge, :like1
    rename_column :appartments, :like_mayra, :like2
  end
end
