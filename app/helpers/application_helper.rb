module ApplicationHelper
  def idsafe_encode64(str)
    Base64.urlsafe_encode64(str).delete '='
  end

  def idsafe_decode64(str)
    Base64.urlsafe_decode64 str + '=' * (-1 * str.size & 3)
  end
end
