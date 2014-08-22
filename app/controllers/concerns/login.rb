module Login
  extend ActiveSupport::Concern
  def need_logged_in
    redirect_to login_path unless logged_in?
  end
end
