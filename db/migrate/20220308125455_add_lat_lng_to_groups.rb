class AddLatLngToGroups < ActiveRecord::Migration[6.0]
  def change
    add_column :groups, :lat, :float 
    add_column :groups, :lng, :float
  end
end
