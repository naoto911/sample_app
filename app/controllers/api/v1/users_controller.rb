class Api::V1::UsersController < ApplicationController
  protect_from_forgery #追記
  before_action :logged_in_user, only: %i[ edit show update destroy ] #このアクションはログイン後しか実行できない
  before_action :set_target_user, only: %i[show edit update destroy]
  before_action :master_user, only: %i[ edit update destroy] #自分自身でないと操作できないアクション
  before_action :check_guest, only: %i[update destroy] #ゲストユーザーは編集,削除不可

  #アカウントがないので新規作成させる
  def new
    @user = User.new
    render json: {user: @user }
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user
    else
      render json: { errors: user.errors.full_messages }, status: 400
    end
  end

  def show
    # #申請中のデータ
    @applications = Join.where(user_id: @user.id).where(level: '2')
    @applicaiton_groups = []
    for @application in @applications do
      @applicaiton_group = Group.find_by(id: @application.group_id)
      @applicaiton_groups.push(@applicaiton_group)
    end

    # #承認中のデータ
    # @groups = Group.where(adminuser_id: @user.id)
    # @approvals = []
    #   for @group in @groups do
    #     @joins = Join.where(group_id: @group.id).where(level: '2')
    #     # if @joins != []
    #     #   @approvals.push(@joins)
    #     # end

    #     for @join in @joins do
    #       if @join != nil
    #         @approvals.push(@join)
    #       end
    #     end
    #   end

    # render json: {user: @user, applications: @applications }
    # render json: {user: @user, applications: @applications, approvals: @approvals, applicaiton_groups: @applicaiton_groups }
    render json: {user: @user, applications: @applications, applicaiton_groups: @applicaiton_groups }
  end

  def edit
    render json: {user: @user, current_user: current_user }
  end

  def update
    if @user.update(user_params)
      render json: @user, status: :created
    else
      render json: { status: 'SUCCESS', message: 'Not updated', data: @user.errors }
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
    render json: { status: 'SUCCESS', message: 'Deleted the user', data: @user }
  end

  #ゲストユーザーログイン機能 1/20追記
  def guest_login
    user = User.find_or_create_by(email: 'guest@example.com')
    user.name = "GuestUser"
    user.password = SecureRandom.urlsafe_base64
    user.save if !user.id #idがない場合、DBに保存してIDを生成
    session[:user_id] = user.id
    redirect_to groups_path, flash: { notice: "「ゲストユーザー」としてログインしました" }
  end

private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmationm, :image, :image_cache)
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
