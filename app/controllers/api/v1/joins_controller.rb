class Api::V1::JoinsController < ApplicationController
  protect_from_forgery #追記
  before_action :logged_in_user, only: %i[show new edit update destroy permit leave] #ログイン後しか実行できない
  before_action :set_target_group, only: %i[show new create edit update destroy permit leave]
  before_action :set_target_join, only: %i[show edit update destroy permit leave]
  before_action :master_user, only: %i[ edit update ] #自分自身でないと操作できないアクション
  before_action :admin_user, only: %i[ permit ] #幹事でないと操作できないアクション
  before_action :destroy_permition, only: %i[ destroy leave ] #自分自身or幹事でないと操作できないアクション

  def new
    @join = Join.new
    render json: {join: @join, current_user: current_user }
  end

  def create
    join = Join.new(join_params)
      if join.save
        render json: join, status: :created
      else
        render json: join.errors, status: :unprocessable_entity
      end
  end

  def update
    if @join.update(join_params)
      render json: @join, status: :created
    else
      render json: { status: 'SUCCESS', message: 'Not updated', data: @join.errors }
    end
  end

  def show
    render json: {group: @group, join: @join, current_user: current_user }
  end

  def edit
  end

  def destroy
    @join.destroy
    render json: { status: 'SUCCESS', message: 'Deleted the post', data: @join }
  end

  #グループ参加申請処理
  def permit
    #グループに参加済みの人の処理
    if @join.level == 1 then
      redirect_back(fallback_location: root_path) #, flash: { notice: "#{@group.name}にすでに参加済みです"}
    #グループに新規参加の人の処理
    else 
      @join.level = 1 #joinのlevelを1(参加済)に変更　
      @join.save
      Event.where(group_id: @group.id).each_with_index do |group_event| #Eventを次々に取得 1/12編集
        group_event.users << User.find(@join.user_id) #Anserに(event_id,user_id)を紐付ける 1/12追記
      end
      redirect_to group_path(@group), flash: { notice: "「#{User.find(@join.user_id).name}が#{@group.name}に参加しました"}
    end
  end 

  def leave
    Event.where(group_id: @group.id).each_with_index do |group_event| #Eventを次々に取得
      leave_user_id = @join.user_id
      # binding.pry
      Answer.find_by(event_id: group_event.id, user_id: leave_user_id).destroy
    end
    @join.destroy
    redirect_to group_path(@group), flash: { notice: "「」が退会しました"}
  end

private

  def join_params
    params.require(:join).permit(:content, :level, :group_id, :user_id)
  end

  def set_target_group
    @group = Group.find(params[:group_id])
  end

  def set_target_join
    @join = Join.find(params[:join_id])
    #@join = Join.find_by(user_id: current_user.id, group_id: params[:group_id]) /paarms[:id]で拾えない場合の処理 多分消す
  end

  #master_user(自分のアカウント)でないと戻す処理
  def master_user
    @user = User.find(@join.user_id)
    unless @user.id == current_user.id
      redirect_back(fallback_location: root_path) #直接urlに入力してきたユーザーは戻す
    end
  end

  #admin_userでないとrootに戻す処理
  def admin_user
    unless @group.adminuser_id == current_user.id
      redirect_back(fallback_location: root_path) #直接urlに入力してきたユーザーはrootに戻す
    end
  end
  
  #admin_user or master_user(自分のアカウント)でないと戻す処理
  def destroy_permition
    @user = User.find(@join.user_id)
    unless @user.id == current_user.id ||  @group.adminuser_id == current_user.id
      redirect_back(fallback_location: root_path) #直接urlに入力してきたユーザーは戻す
    end
  end

end
