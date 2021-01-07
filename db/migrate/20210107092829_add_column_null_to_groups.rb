class AddColumnNullToGroups < ActiveRecord::Migration[6.0]
  def change
    change_column_null :groups, :name, false
    change_column_null :groups, :introduction, false
  end
end
