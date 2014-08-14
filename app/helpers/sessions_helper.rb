module SessionsHelper
  def sign_in(user)
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

  def signed_in_user_name
    signed_in? ? @current_user.name : 'ゲスト'
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    self.current_user = nil
    cookies.delete :remember_token
  end

  def logout_or_login
    if signed_in?
      link_to 'ログアウトする', signout_path, method: :delete
    else
      link_to 'ログインする', new_session_path
    end
  end
end
