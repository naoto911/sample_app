class Api::V1::JoinsController < ApplicationController
  protect_from_forgery #追記
  before_action :logged_in_user, only: %i[show new edit update destroy permit deny leave] #ログイン後のみ実行可能
  before_action :set_target_group, only: %i[show new create edit update destroy permit deny leave]
  before_action :set_target_join, only: %i[show edit update destroy permit deny leave]
  before_action :master_user, only: %i[ edit update ] #自分自身でないと操作できないアクション
  before_action :admin_user, only: %i[ permit ] #幹事でないと操作できないアクション
  before_action :destroy_permition, only: %i[ destroy deny leave ] #自分自身or幹事でないと操作できないアクション

  def new
    @join = Join.new
    render json: {join: @join, current_user: current_user }
  end

  def create
    join = Join.new(join_params)
      if join.save
        # render json: join, status: :created
        render json: { join: join }
      else
        # render json: join.errors, status: :unprocessable_entity
        render json: { join: join }
      end
  end

  def update
    if @join.update(join_params)
      # render json: @join, status: :created
      render json: { join: @join }
    else
      # render json: { status: 'SUCCESS', message: 'Not updated', data: @join.errors }
      render json: { join: @join }
    end
  end

  def show
    render json: {group: @group, join: @join, current_user: current_user }
  end

  def edit
  end

  def destroy
    #--------------------元々のコードたち--------------------
    if @join.level == 1 then  #所属済ユーザー退会時の処理 関連するanswerを先に全て削除
      Event.where(group_id: @join.group_id).each_with_index do |group_event| #Eventを次々に取得 1/12編集
        destroy_answer = group_event.answers.find_by(user_id: @join.user_id)
        destroy_answer.destroy if destroy_answer != nil #削除予定のuserに関するanswerを次々に削除
      end
    else #所属前のユーザー自身による申請削除
    end
    
    @join.destroy
    render json: {join: @join, current_user: current_user }
  end

  def permit #申請承認
    #--------------------N+1改善ver--------------------
    if @join.level == 1 then #すでに所属済みの場合,何もせず,API処理を終了させる
    else 
      @join.level = 1
      @join.save

      #参加するUser用にAnswerを作成するための処理 (GroupのEvent数分,Answerを新規作成)
      @user = User.find(@join.user_id)
      @user_group =  Group.includes(events: :users).find_by(id: @group.id)

      @user_group.events.each do |group_event|
        group_event.users << @user
      end
    end

    render json: { join: @join }

    #--------------------元々のコードたち--------------------
    # if @join.level == 1 then #すでに所属済みの場合,何もせず,API処理を終了させる
    # else 
    #   @join.level = 1
    #   @join.save

    #   #参加するUser用にAnswerを作成するための処理 (GroupのEvent数分,Answerを新規作成)
    #   Event.where(group_id: @join.group_id).each_with_index do |group_event| #Eventを次々に取得 1/12編集
    #     group_event.users << User.find(@join.user_id) #Anserに(event_id,user_id)を紐付ける 1/12追記
    #   end
    # end
    # render json: { status: 'SUCCESS', message: 'Permit the Application', data: @join }
    # render json: { join: @join }
  end 

  def deny #申請拒否
    if @join.level == 1 then #すでに所属済みの場合,何もせず,API処理を終了させる
    else 
      @join.destroy
    end
    # render json: { status: 'SUCCESS', message: 'Deny the Application', data: @join }
    render json: { join: @join }
  end

  # def leave #退会処理 groups_ctontrollerへ移動する
  #   Event.where(group_id: @group.id).each_with_index do |group_event| #Eventを次々に取得
  #     leave_user_id = @join.user_id
  #     Answer.find_by(event_id: group_event.id, user_id: leave_user_id).destroy
  #   end
  #   @join.destroy
  #   redirect_to group_path(@group), flash: { notice: "「」が退会しました"}
  # end

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
