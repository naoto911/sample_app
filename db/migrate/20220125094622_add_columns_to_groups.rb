class AddColumnsToGroups < ActiveRecord::Migration[6.0]
  def change
    add_column :groups, :frequency, :integer
    add_column :groups, :region, :integer
    add_column :groups, :instagram, :string
  end
end
