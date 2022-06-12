require 'rails_helper'

RSpec.describe Group, type: :model do

  describe 'Validation' do
    
    before do
      @user = create(:user)
      @group = build(:group, adminuser_id: @user.id)
    end

    it '正しい入力の場合は有効' do
      @group.valid?
      expect(@group).to be_valid
    end
    
    it 'nameが未入力の場合は無効' do
      @group = build(:group, name: nil, introduction: "test")
      @group.name = nil
      @group.valid?
      expect(@group.errors[:name]).to include("can't be blank")
    end

    it 'introductionが未入力の場合は無効' do
      @group.introduction = nil
      @group.valid?
      expect(@group.errors[:introduction]).to include("can't be blank")
    end

    it 'nameが10文字以下なら有効' do
      @group.name = "0123456789"
      @group.valid?
      expect(@group).to be_valid
    end

    it 'nameが10文字を超えると無効' do
      @group.name = "0123456789X"
      @group.valid?
      expect(@group.errors[:name]).to include("is too long (maximum is 10 characters)")
    end

    it 'nameがユニークであること' do
      @group.name = "group1"
      @group.save
      @group2 = build(:group , name: "group1")
      @group2.valid?
      expect(@group2.errors[:name]).to include("has already been taken")
    end

  end

  # describe 'Association' do
  # end
  
end
