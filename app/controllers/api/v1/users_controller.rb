class Api::V1::UsersController < ApplicationController
  protect_from_forgery #追記
  before_action :logged_in_user, only: %i[ edit show update destroy ] #このアクションはログイン後しか実行できない
  before_action :set_target_user, only: %i[show edit update destroy]
  before_action :master_user, only: %i[ edit update destroy] #自分自身でないと操作できないアクション
  before_action :check_guest, only: %i[ update destroy] #ゲストユーザーは編集,削除不可 
  
  def new #アカウントがないので新規作成させる
    @user = User.new
    render json: {user: @user }
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user
    else
      # render json: { errors: user.errors.full_messages }, status: 400
      render json: user
    end
  end

  def show
    #--------------------N+1改善ver--------------------
    #申請依頼中のgroup一覧
    @applications = Join.includes(:group).where(user_id: @user.id).where(level: 2)
    @applicaiton_groups = []
    @applications.each do |application|
        @applicaiton_groups.push(application.group)
    end

    @applicaiton_groups_count = @applicaiton_groups.length

    #Mygroup一覧のための準備
    @user_joins = Join.includes(:group).where(user_id: @user.id).where(level: 1)
    @user_groups = []
    @user_joins.each do |user_join|
      @user_groups.push(user_join.group)
    end

    #参加予定eventの取得
    @user_answers = Answer.includes(:event).where(user_id: @user.id)
    @user_join_answers = @user_answers.where("answer= '○'")
    @join_events = []
    @user_join_answers.each do |user_join_answer|
      @join_events.push(user_join_answer.event)
    end

    #お気に入りグループの取得
    @user_favorites = Favorite.includes(:group).where(user_id: @user.id)
    @user_favorites_groups = []
    @user_favorites.each do |user_favorite|
      @user_favorites_groups.push(user_favorite.group)
    end

    render json: {
      user: @user, 
      applications: @applications, 
      applicaiton_groups: @applicaiton_groups, 
      user_groups: @user_groups, 
      join_events: @join_events, 
      user_favorites_groups: @user_favorites_groups, 
      user_join_answers: @user_join_answers, 
      applicaiton_groups_count: @applicaiton_groups_count 
    }

    #--------------------元々のコードたち--------------------
    #申請中のデータ
    # @applications2 = Join.where(user_id: @user.id).where(level: '2')
    # @applicaiton_groups2 = []
    # for @application2 in @applications2 do
    #   @applicaiton_group2 = Group.find_by(id: @application2.group_id)
    #   @applicaiton_groups2.push(@applicaiton_group2)
    # end

    #my group一覧のための準備
    # @user_joins2=  @user.joins.where(level: 1)
    # @user_groups2 = []
    # for @user_join2 in @user_joins2 do
    #   @user_group2 = Group.find_by(id: @user_join2.group_id)
    #   @user_groups2.push(@user_group2)
    # end

    # #参加予定eventの取得
    # @user_answers2 = @user.answers #.where("answer = '○'")
    # @user_join_answers2 = @user_answers2.where("answer= '○'")
    # @join_events2 = []
    # for @user_join_answer2 in @user_join_answers2 do
    #   @join_event2 = @user_join_answer2.event
    #   @join_events2.push(@join_event2)
    # end
    
    # #お気に入りグループの取得
    # @user_favorites2 = @user.favorites
    # @user_favorites_groups2 = []
    # for @user_favorite2 in @user_favorites2 do
    #   @user_favorites_group2 = Group.find_by(id: @user_favorite2.group_id)
    #   @user_favorites_groups2.push(@user_favorites_group2)
    # end

    #--------------------ここで検証--------------------
    # @bool = false
    # if @applicaiton_groups2 == @applicaiton_groups && @user_favorites_groups2 === @user_favorites_groups
    #   @bool = true
    # end

    # render json: { bool: @bool, 
    #             }

    # render json: {user: @user, applications: @applications, applicaiton_groups: @applicaiton_groups, user_groups: @user_groups, join_events: @join_events, user_favorites_groups: @user_favorites_groups }

  end

  def edit
    render json: {user: @user, current_user: current_user }
  end

  def update
    if @user.update(user_params)
      # render json: @user, status: :created
      render json: {user: @user }
    else
      # render json: { status: 'SUCCESS', message: 'Not updated', data: @user.errors }
      render json: {user: @user }
    end
  end

  def destroy
    @groups = @user.groups.all #userに所属するuserを配列で取得
    @groups.each do |check_group|
      if check_group.adminuser_id == @user.id then
        check_group.destroy
      end
    end

    @user.destroy
    # render json: { status: 'SUCCESS', message: 'Deleted the user', data: @user }
    render json: {user: @user }
  end

  #ゲストユーザーログイン機能 1/20追記
  def guest_login
    user = User.find_or_create_by(email: 'guest@example.com')
    user.name = "GuestUser"
    user.password = SecureRandom.urlsafe_base64
    user.save if !user.id #idがない場合、DBに保存してIDを生成
    session[:user_id] = user.id
    # render json: user, status: :created
    render json: { user: user }
    # redirect_to groups_path, flash: { notice: "「ゲストユーザー」としてログインしました" }
  end

private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmationm, :image, :image_cache, :sex, :age, :birthplace , :introduction )
  end

  def set_target_user
    @user = User.find(params[:id])
  end
  
  #master_user(自分のアカウント)でないと戻す処理
  def master_user
    unless @user.id == current_user.id
      redirect_back(fallback_location: root_path) #直接urlに入力してきたユーザーは戻す
    end
  end

  #ゲストユーザーは変更・削除できない使用 1/20追加
  def check_guest
    if @user.email == 'guest@example.com'
      redirect_to root_path, flash: { notice: "「ゲストユーザー」は変更・削除できません" }
    end
  end

end
