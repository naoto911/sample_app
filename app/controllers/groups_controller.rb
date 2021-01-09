class GroupsController < ApplicationController
  before_action :set_target_group, only: %i[show edit update destroy]
  before_action :logged_in_user, only: %i[new edit update destroy] #このアクションはログイン後しか実行できない
  
  def index
    @groups = Group.all
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
    binding.pry
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
    #binding.pry
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path
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
    params.require(:group).permit(:name, :introduction)
  end

  def set_target_group
    @group = Group.find(params[:id])
  end
  
end
