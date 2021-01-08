class AddadminuserIdToGroups < ActiveRecord::Migration[6.0]
  def change
    add_column :groups, :adminuser_id, :string
  end
end