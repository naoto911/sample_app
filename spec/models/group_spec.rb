# require 'rails_helper'

# RSpec.describe Group, type: :model do

#   describe 'Validation' do
    
#     before do
#       @user = create(:user)
#       @group = build(:group, adminuser_id: @user.id)
#     end

#     it '正しい入力の場合は有効' do
#       @group.valid?
#       expect(@group).to be_valid
#     end
    
#     it 'nameが未入力の場合は無効' do
#       @group = build(:group, name: nil, introduction: "test")
#       @group.name = nil
#       @group.valid?
#       expect(@group.errors[:name]).to include("can't be blank")
#     end

#     it 'introductionが未入力の場合は無効' do
#       @group.introduction = nil
#       @group.valid?
#       expect(@group.errors[:introduction]).to include("can't be blank")
#     end

#     it 'nameが10文字以下なら有効' do
#       @group.name = "0123456789"
#       @group.valid?
#       expect(@group).to be_valid
#     end

#     it 'nameが10文字を超えると無効' do
#       @group.name = "0123456789X"
#       @group.valid?
#       expect(@group.errors[:name]).to include("is too long (maximum is 10 characters)")
#     end

#     it 'nameがユニークであること' do
#       @group.name = "group1"
#       @group.save
#       @group2 = build(:group , name: "group1")
#       @group2.valid?
#       expect(@group2.errors[:name]).to include("has already been taken")
#     end
#   end

#   describe 'Association has_many' do
#     let(:association) do
#       # reflect_on_associationで対象のクラスと引数で指定するクラスの
#       # 関連を返します
#       described_class.reflect_on_association(target)
#     end

#     # usersとの関連付けをチェックしたい場合
#     context 'users' do
#       let(:target) { :users } # targetは :users に設定
#       it { expect(association.macro).to eq :has_many } # macro メソッドで関連づけを返します
#       it { expect(association.class_name).to eq 'User' } # class_name で関連づいたクラス名を返します
#     end

#     # favoritesとの関連付けをチェックしたい場合
#     context 'favorites' do
#       let(:target) { :favorites } # targetは :favorites に設定
#       it { expect(association.macro).to eq :has_many } # macro メソッドで関連づけを返します
#       it { expect(association.class_name).to eq 'Favorite' } # class_name で関連づいたクラス名を返します
#     end

#     # joinsとの関連付けをチェックしたい場合
#     context 'joins' do
#       let(:target) { :joins } # targetは :joins に設定
#       it { expect(association.macro).to eq :has_many } # macro メソッドで関連づけを返します
#       it { expect(association.class_name).to eq 'Join' } # class_name で関連づいたクラス名を返します
#     end

#     # eventsとの関連付けをチェックしたい場合
#     context 'events' do
#       let(:target) { :events } # targetは :events に設定
#       it { expect(association.macro).to eq :has_many } # macro メソッドで関連づけを返します
#       it { expect(association.class_name).to eq 'Event' } # class_name で関連づいたクラス名を返します
#     end
#   end

#   describe 'Association destroy depend' do
#     before do
#         @user = create(:user)
#         @group = create(:group, adminuser_id: @user.id)
#     end

#     it 'groupを削除すると、groupが作成したjoinsも削除されること' do
#       @join = create(:join, group_id: @group.id, user_id: @user.id)
#       expect{ @group.destroy }.to change{ Join.count }.by(-1)
#     end

#     it 'groupを削除すると、groupが作成したfavoritesも削除されること' do
#       @favorite = create(:favorite, group_id: @group.id, user_id: @user.id)
#       expect{ @group.destroy }.to change{ Favorite.count }.by(-1)
#     end

#     it 'groupを削除すると、groupが作成したeventsも削除されること' do
#       @event = create(:event, group_id: @group.id)
#       expect{ @group.destroy }.to change{ Event.count }.by(-1)
#     end


#   end

# end
