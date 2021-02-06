class Join < ApplicationRecord

# ==============バリデーション ================================
  #join情報の内,以下は未入力は不可
  with_options presence: true do
    validates :level
  end

# ==============アソシエーション ================================
  #中間テーブル (user-Join-event)
  belongs_to :user
  belongs_to :group
end
