class Group < ApplicationRecord

# ==============画像uploader機能 ================================
  mount_uploader :image, ImageUploader
# ==============バリデーション ================================
  #グループ情報は未入力は不可
  with_options presence: true do
    validates :name
    validates :introduction
  end
  #groupの名前にvalidateをかける
  validates :name, length: {maximum: 10}  
  validates :name, uniqueness: true       #nameは重複不可

# ==============アソシエーション ================================
  #join用 (多対多)
  has_many :joins, dependent: :destroy
  has_many :users, through: :joins
  #event用(1対多) (Groupv対Event)
  has_many :events, dependent: :destroy
end
