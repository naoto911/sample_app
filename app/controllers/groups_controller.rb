class GroupsController < ApplicationController
  before_action :logged_in_user, only: %i[show new edit update destroy join] #ログイン後しか実行できないアクション
  before_action :set_target_group, only: %i[show edit update destroy join]
  before_action :admin_user, only: %i[edit update destroy] #幹事でないと操作できないアクション

  def index
    #@groups = Group.all
    @groups = Group.order(id: :asc) #idの昇順に表示
  end

  def show
    @users = @group.users.all #groupに所属するuserを配列で取得
    @admin_user = @users.find_by(id: @group.adminuser_id) #管理者をgroupのadminuser_idから取得
  end

  def new
    @group = Group.new
  end

  def create
    group = Group.new(group_params)
    group.adminuser_id = current_user.id #group作成中のidをgroupモデルのaddminuser_idに格納
    group.users << current_user #group_user_relationsにidを格納させる
    if group.save
      flash[:notice] = "「#{group.name}」を作成しました"
      redirect_to groups_path
    else
  #フォームの入力エラーを起こした際のエラー表示を取得するための処理
      redirect_to new_group_path, flash: {
        group: group,
        error_messages: group.errors.full_messages
      }
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to group_path(@group)
    else
  #フォームの入力エラーを起こした際のエラー表示を取得するための処理
      redirect_to edit_group_path, flash: {
      group: @group,
      error_messages: @group.errors.full_messages
    }
    end
  end

  def destroy
    @group.destroy
    redirect_to groups_path, flash: { notice: "「#{@group.name}」が削除されました"}
  end

private

  def group_params
    params.require(:group).permit(:name, :introduction, :image, :image_cache)
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
