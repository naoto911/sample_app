class Join < ApplicationRecord

# ==============アソシエーション ================================
#中間テーブル (user-join-group)
  belongs_to :user
  belongs_to :group
end
