class User < ApplicationRecord

# ==============画像uploader機能 ================================
  mount_uploader :image, ImageUploader
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
  #favorite用 (多対多)
  has_many :favorites, dependent: :destroy
  has_many :groups, through: :favorites
  #join用 (多対多)
  has_many :joins, dependent: :destroy
  has_many :groups, through: :joins
  #Answer用 (多対多)
  has_many :answers, dependent: :destroy
  has_many :events, through: :answers
end