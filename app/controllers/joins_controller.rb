class JoinsController < ApplicationController
  before_action :logged_in_user, only: %i[show new edit update destroy permit] #このアクションはログイン後しか実行できない
  before_action :set_target_group, only: %i[show new create edit update destroy permit]
  before_action :set_target_join, only: %i[show edit update destroy permit]
  before_action :master_user, only: %i[ edit update destroy] #自分自身でないと操作できないアクション

  def new
    @join = Join.new
  end

  def create
    join = Join.new(join_params)
    join.user_id = current_user.id
    if join.save
      flash[:notice] = "「参加申請」が完了しました"
      redirect_to group_path(@group)
    else
  #フォームの入力エラーを起こした際のエラー表示を取得するための処理
      redirect_to new_group_join_path, flash: {
        join: join,
        error_messages: join.errors.full_messages
      }
    end
  end

  def update
    if @join.update(join_params)
      flash[:notice] = "「参加申請」を更新しました"
      redirect_to user_path(current_user)
    else
  #フォームの入力エラーを起こした際のエラー表示を取得するための処理
      redirect_to edit_group_join_path(@join), flash: {
        join: @join,
        error_messages: @join.errors.full_messages
    }
    end
  end

  def show
  end

  def edit
  end

  #グループ参加申請処理
  def permit
    #グループに参加済みの人の処理
    if @group.users.ids.include?(current_user.id) then
      redirect_to group_path(@group), flash: { notice: "#{@group.name}にはすでに参加済みです"}
    #グループに新規参加の人の処理
    else 
      @group.users << current_user #joinにidを格納させる
      Event.where(group_id: @group.id).each_with_index do |group_event| #Eventを次々に取得 1/12編集
        group_event.users << current_user #Anserに(event_id,user_id)を紐付ける 1/12追記
      end
      redirect_to group_path(@group), flash: { notice: "「#{current_user.name}が#{@group.name}に参加しました"}
    end
  end 

  def destroy
    @join.destroy
    redirect_to user_path(current_user), flash: { notice: "「#{@group.name}」への参加申請が削除されました"}
  end

private

  def join_params
    params.require(:join).permit(:content, :level).merge(group_id: params[:group_id])
  end

  def set_target_group
    @group = Group.find(params[:group_id])
  end

  def set_target_join
    @join = Join.find(params[:id])
    #@join = Join.find_by(user_id: current_user.id, group_id: params[:group_id]) /paarms[:id]で拾えない場合の処理 多分消す
  end

  #master_user(自分のアカウント)でないと戻す処理
    def master_user
      @user = User.find(@join.user_id)
      unless @user.id == current_user.id
        redirect_back(fallback_location: root_path) #直接urlに入力してきたユーザーは戻す
      end
    end

end
