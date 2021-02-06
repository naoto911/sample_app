class AddLevelToJoins < ActiveRecord::Migration[6.0]
  def change
    add_column :joins, :level, :integer, default: 1,null: false
    add_column :joins, :content, :text
  end
end
