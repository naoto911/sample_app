class Api::V1::SessionsController < ApplicationController
  # protect_from_forgery #追記

  def new
  end

  #login処理
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      # redirect_to root_url #user_path(user) #root_url
      # render json: user
      # redirect_to  root_url #api_v1_user_path(user)
      # render json: user, status: :created
      render json: { user: user }
    else
      render json: { errors: ['ログインに失敗しました'] }, status: 401
    end
  end

  def destroy
    #「真(true)」となった場合に実行したい処理 if 条件式
    log_out if logged_in?
    # redirect_to root_url
  end

end
