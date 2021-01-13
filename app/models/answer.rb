class Answer < ApplicationRecord

  # ==============バリデーション ================================
  #answer情報の内,以下は未入力は不可
  with_options presence: true do
    validates :answer
  end

# ==============アソシエーション ================================
  #中間テーブル (user-Answer-event)
  belongs_to :user
  belongs_to :event
end