class Event < ApplicationRecord

# ==============バリデーション ================================
  #event情報内以下は未入力は不可
  with_options presence: true do
    validates :date
    validates :place
  end

# ==============アソシエーション ================================
  #group用(多対1) (Event対Eroup)
  belongs_to :group
  has_many :answers, dependent: :destroy
  has_many :users, through: :answers
end
