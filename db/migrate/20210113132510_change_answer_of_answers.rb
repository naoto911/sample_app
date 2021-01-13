class ChangeAnswerOfAnswers < ActiveRecord::Migration[6.0]
  def change
    change_column :answers, :answer, :string, default: '-'
    change_column_null :answers, :answer, false
  end
end
