class User < ApplicationRecord

# ==============バリデーション ================================
  #ユーザー認証のpassword用の設定
  has_secure_password
  #ユーザー認証登録時に必要な情報は未入力は不可
  with_options presence: true do
    validates :name
    validates :email
    validates :password_digest
  end
  #emailは重複不可
  validates :email, uniqueness: true

# ==============アソシエーション ================================
  has_many :user_group_relations
  has_many :groups, through: :user_group_relations
end