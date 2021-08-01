class AddDuplexToAppartments < ActiveRecord::Migration[5.2]
  def change
    add_column :appartments, :duplex, :boolean
  end
end
