require 'rails_helper'

describe "GET /groups" do
  before do
    @user = create(:user)
    @group = create(:group, name: "テスト", adminuser_id: @user.id)
    @join = create(:join, group_id: @group.id, user_id: @user.id)
  end
  it 'ユーザー一覧が表示されること' do
    get "/api/v1/groups"
    json = JSON.parse(response.body)

    # リクエスト成功を表す200が返ってきたか確認する。
    expect(response.status).to eq(200)

    # group総数が↑で作成した1つだけであることを確認する。
    expect(json['groups'].count).to eq(1)
  end
end


describe "GET /groups/:id" do
  before do
    @user = create(:user)
    @group = create(:group, name: "テスト", adminuser_id: @user.id)
    @join = create(:join, group_id: @group.id, user_id: @user.id)

    # ユーザーIDをセッションから取り出せるようにする
    allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: @user.id)
  end
  it '特定のgroupを取得する' do
    get "/api/v1/groups/#{@group.id}"
    json = JSON.parse(response.body)

    # リクエスト成功を表す200が返ってきたか確認する。
    expect(response.status).to eq(200)

    # 要求した特定のgroupのみ取得した事を確認する
    expect(json['group']['name']).to eq(@group.name)
    expect(json['group']['adminuser_id']).to eq(@user.id)
  end
end

describe "POST /groups"  do

  before do
    @user = create(:user)
    # @group = build(:group, name: "テスト", adminuser_id: @user.id)
  end

  it '新しいpostを作成する' do
    # valid_params = { name: 'POST用のテスト', introduction: 'post用のテストです' , adminuser_id: @user.id }
    #  expect { post '/api/v1/groups', params: { group: valid_params } }.to change(Group, :count).by(+1)
    valid_params = { group: {
      name: 'test2', 
      introduction: 'post用のテストです',
      adminuser_id: @user.id,
      } 
    }

     #データが作成されている事を確認
     expect { post '/api/v1/groups', params: valid_params }.to change(Group, :count).by(+1)
    
     # リクエスト成功を表す200が返ってきたか確認する。
     expect(response.status).to eq(201)
   end
 end