require 'rails_helper'

describe "GET /groups" do
  before do
    @user = create(:user)
    @group = create(:group, name: "テスト", adminuser_id: @user.id)
    @join = create(:join, group_id: @group.id, user_id: @user.id)
  end
  it 'group一覧が表示されることの検証' do
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
  it '特定のgroupが取得できることの検証' do
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
  end
  it 'Groupをpostできることの検証' do
    valid_params = { group: {
      name: 'test2', 
      introduction: 'post用のテストです',
      adminuser_id: @user.id,
      } 
    }

     #データが作成されている事を確認
     expect { post '/api/v1/groups', params: valid_params }.to change(Group, :count).by(+1)
    
     # リクエスト成功を表す201が返ってきたか確認する。
     expect(response.status).to eq(201)
   end
 end

describe "PUT /groups/:id"  do
  before do
    @user = create(:user)
    @group = create(:group, name: "old-group", adminuser_id: @user.id)
    @join = create(:join, group_id: @group.id, user_id: @user.id)

    # ユーザーIDをセッションから取り出せるようにする
    allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: @user.id)
  end
  it 'Groupの編集ができることの検証' do
    put "/api/v1/groups/#{@group.id}", params: { group: {name: "new-group"}  }
    json = JSON.parse(response.body)

    # リクエスト成功を表す201が返ってきたか確認する。
    expect(response.status).to eq(201)

    #データが更新されている事を確認
    expect(json['group']['name']).to eq("new-group")
 end
end

describe "DELETE /groups/:id"  do
  before do
    @user = create(:user)
    @group = create(:group, name: "テスト", adminuser_id: @user.id)
    @join = create(:join, group_id: @group.id, user_id: @user.id)

    # ユーザーIDをセッションから取り出せるようにする
    allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return(user_id: @user.id)
  end
  it 'Groupが削除できることの検証' do
    expect do
      delete "/api/v1/groups/#{@group.id}"
      expect(response.status).to eq(200)
    end.to change{ Group.count }.by(-1)
  end
end