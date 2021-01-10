class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.references :group, null: false, foreign_key: true
      t.date :date, null: false
      t.time :starttime
      t.time :finishtime
      t.string :place, null: false
      t.text :remarks

      t.timestamps
    end
  end
end
