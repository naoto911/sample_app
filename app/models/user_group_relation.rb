class UserGroupRelation < ApplicationRecord

# ==============アソシエーション ================================
#中間テーブル (user-user_group_relations-group)
  belongs_to :user
  belongs_to :group
end
