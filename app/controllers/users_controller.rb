class UsersController < ApplicationController
  before_action :set_target_user, only: %i[show edit update destroy]
  before_action :logged_in_user, only: %i[ show edit update destroy] #このアクションはログイン後しか実行できない
  
  def index
  end

  #アカウントがないので新規作成させる
  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    if user.save
      flash[:notice] = "「#{user.name}」を作成しました"
      log_in user #アカウント作成と同時にログインする
      redirect_to user_path(user)
    else
  #フォームの入力エラーを起こした際のエラー表示を取得するための処理
      redirect_to new_user_path, flash: {
        user: user,
        error_messages: user.errors.full_messages
      }
    end
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
  #フォームの入力エラーを起こした際のエラー表示を取得するための処理
      redirect_to edit_user_path, flash: {
        user: @user,
        error_messages: @user.errors.full_messages
    }
    end
  end

  def destroy
    @user.destroy
    redirect_to groups_path, flash: { notice: "「#{@user.name}」が削除されました"}
  end

private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def set_target_user
    @user = User.find(params[:id])
  end

end
