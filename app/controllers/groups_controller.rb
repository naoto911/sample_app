class GroupsController < ApplicationController
  before_action :set_target_group, only: %i[show edit update destroy]
  before_action :logged_in_user, only: %i[new edit update destroy] #このアクションはログイン後しか実行できない
  
  def index
    @groups = Group.all
  end

  def show
    #@users = User.all
  end

  def new
    @group = Group.new
    #@group.users << current_user
    @group.user_group_relations.build #追加
  end

  def create
    group = Group.new(group_params)
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
    binding.pry
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
    params.require(:group).permit(:name, :introduction, { user_ids: [] })
  end

  def set_target_group
    @group = Group.find(params[:id])
  end
  
end
