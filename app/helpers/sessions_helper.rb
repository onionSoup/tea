module SessionsHelper
  def log_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token,User.encrypt(remember_token))
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def logged_in_user_name
    logged_in? ? @current_user.name : 'ゲスト'
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    self.current_user = nil
    cookies.delete :remember_token
  end

  def logout_or_login
    if logged_in?
      link_to 'ログアウトする', logout_path, method: :delete
    else
      link_to 'ログインする', login_path
    end
  end
end
