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
  #   if user.save
  #     flash[:notice] = "「#{user.name}」を作成しました"
  #     log_in user #アカウント作成と同時にログインする
  #     redirect_to  user_path(user)
  #   else
  # #フォームの入力エラーを起こした際のエラー表示を取得するための処理
  #     redirect_to new_user_path, flash: {
  #       user: user,
  #       error_messages: user.errors.full_messages
  #     }
  #   end
  end

  def show
    render json: {user: @user }
  end

  def edit
    render json: {user: @user, current_user: current_user }
  end

  def update
    if @user.update(user_params)
      # redirect_to user_path(@user)
      render json: @user, status: :created
      # render json: user: @user, status: :created
    else
      render json: { status: 'SUCCESS', message: 'Not updated', data: @user.errors }
  #フォームの入力エラーを起こした際のエラー表示を取得するための処理
    #   redirect_to edit_user_path, flash: {
    #     user: @user,
    #     error_messages: @user.errors.full_messages
    # }
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
    # redirect_to groups_path, flash: { notice: "「#{@user.name}」が削除されました"}
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
