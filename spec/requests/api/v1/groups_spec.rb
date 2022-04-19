require 'rails_helper'

describe "GET /groups" do
  it 'ユーザー一覧が表示されること' do
    get "/api/v1/groups"
    json = JSON.parse(response.body)

    # リクエスト成功を表す200が返ってきたか確認する。
    expect(response.status).to eq(200)
  end
end

# describe "GET /groups" do
#   it '特定のgroupを取得する' do
#     # group = create(:group, name: 'test-group')

#     get "/api/v1/groups/#{group.id}"
#     json = JSON.parse(response.body)

#     # リクエスト成功を表す200が返ってきたか確認する。
#     expect(response.status).to eq(200)

#     # 要求した特定のgroupのみ取得した事を確認する
#     # expect(json['data']['name']).to eq(group.title)
#   end
# end