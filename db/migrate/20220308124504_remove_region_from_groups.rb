class RemoveRegionFromGroups < ActiveRecord::Migration[6.0]
  def change
    remove_column :groups, :region, :integer
  end
end
