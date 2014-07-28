#_を入れると動かない？っぽいのでsign_in.rbにしない
module Signin
  extend ActiveSupport::Concern
  def need_signed_in
    redirect_to new_session_path unless signed_in?
  end
end
