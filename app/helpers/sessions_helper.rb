module SessionsHelper

  # 渡されたユーザーでログインする
  #ブラウザのcookieに、ハッシュ化したユーザーidを保存するメソッド
  def log_in(user)
    session[:user_id] = user.id
  end

  # 現在ログイン中のユーザーを返す (いる場合)
  #cookieに保存されたユーザーidを元に、ユーザーの情報を取得するメソッド
  def current_user
    if session[:user_id]
     #@current_user = @current_user || User.find_by(id: session[:user_id])と同じ意味
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # 受け取ったユーザーがログイン中のユーザーと一致すればtrueを返す
  # マイページなど、ログイン中のユーザーにしか表示させたく無いページのbefore_actionでよく使う
  def current_user?(user)
    user == current_user
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  # 現在のユーザーがログインしているかどうかを判別するメソッド
  # ログイン状況に応じて表示する画面を切り替えたりする処理が簡単に実装できるようになる
  def logged_in?
    !current_user.nil?
  end

  # 現在のユーザーをログアウトする
  # ブラウザのcookieに保存されているユーザーidを削除するメソッド
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
  
end
