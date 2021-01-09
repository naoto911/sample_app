class Group < ApplicationRecord

# ==============バリデーション ================================
  #グループ情報はから入力は不可
  with_options presence: true do
    validates :name
    validates :introduction
  end
  #groupの名前にvalidateをかける
  validates :name, length: {maximum: 10}  
  validates :name, uniqueness: true       #nameは重複不可

# ==============アソシエーション ================================
  has_many :user_group_relations, dependent: :destroy
  has_many :users, through: :user_group_relations
end
