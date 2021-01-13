class Event < ApplicationRecord

# ==============バリデーション ================================
  #event情報の内,以下は未入力は不可
  with_options presence: true do
    validates :date
    validates :place
  end

# ==============アソシエーション ================================
  #group用(多対1) (Event対Group)
  belongs_to :group
  #Answer用 (多対多)
  has_many :answers, dependent: :destroy
  has_many :users, through: :answers
end
