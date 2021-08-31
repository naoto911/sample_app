class Api::V1::GroupsController < ApplicationController
  protect_from_forgery #追記
  before_action :logged_in_user, only: %i[show new edit update destroy join] #ログイン後しか実行できないアクション
  before_action :set_target_group, only: %i[show edit update destroy join]
  before_action :admin_user, only: %i[edit update destroy] #幹事でないと操作できないアクション

  def index
    @groups = Group.order(id: :asc) #idの昇順に表示
    render json: {groups: @groups, current_user: current_user }
  end

  def show
    @joins = Join.where(group_id: @group.id)
    @users = []
      for @join in @joins do
          if @join.level == 1
            @user = User.find_by(id: @join.user_id)
            @users.push(@user)
          end
      end
    @admin_user = User.find_by(id: @group.adminuser_id) #管理者をgroupのadminuser_idから取得
    render json: {group: @group, users: @users, admin_user: @admin_user }

  end

  def new
    @group = Group.new
    render json: {group: @group, current_user: current_user }
  end

  def create
    group = Group.new(group_params)
    current_user = User.find(group.adminuser_id)
    group.users << current_user #group_user_relationsにidを格納させる
    if group.save
      render json: group, status: :created
    else
      render json: group.errors, status: :unprocessable_entity
    end
  end

  def edit
    render json: {group: @group, current_user: current_user }
  end

  def update
    if @group.update(group_params)
      render json: @group, status: :created
    else
      render json: { status: 'SUCCESS', message: 'Not updated', data: @group.errors }
    end
  end

  def destroy
    @group.destroy
    render json: { status: 'SUCCESS', message: 'Deleted the post', data: @group }
  end

private

  def group_params
    params.require(:group).permit(:name,:adminuser_id, :introduction, :image, :image_cache)
  end

  def set_target_group
    @group = Group.find(params[:id])
  end

  #admin_userでないとrootに戻す処理
  def admin_user
    unless @group.adminuser_id == current_user.id
      redirect_back(fallback_location: root_path) #直接urlに入力してきたユーザーはrootに戻す
    end
  end

end
