class Event < ApplicationRecord

# ==============バリデーション ================================
  #event情報内以下は未入力は不可
  with_options presence: true do
    validates :date
    validates :place
  end

# ==============アソシエーション ================================
  belongs_to :group
end
