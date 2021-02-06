class ChangeUserGroupRelationsToJoins < ActiveRecord::Migration[6.0]
  def change
    rename_table :user_group_relations, :joins
  end
end
