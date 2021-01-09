class ChangeAdminuserIdToGroups < ActiveRecord::Migration[6.0]
  def change
    change_column :groups, :adminuser_id, 'integer USING CAST(adminuser_id AS integer)'
  end
end