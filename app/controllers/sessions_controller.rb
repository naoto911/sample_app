class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to user_path(user) #root_url
    else
      render 'new'
    end
  end

  def destroy
    #「真(true)」となった場合に実行したい処理 if 条件式
    log_out if logged_in?
    redirect_to root_url
  end

end
