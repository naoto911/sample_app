class Favorite < ApplicationRecord

# ==============アソシエーション ================================
#中間テーブル (user-favorite-group)
  belongs_to :user
  belongs_to :group
end
