module ApplicationHelper
  #本来どこかのモデルに書くべきロジック。モデルを上手く作れなかったのでここに書く。
  def conditions_to_get_details_index
    conditions = [
      current_user.order.registered?,
      Period.enabled?,
      Period.include_now?
    ]

    conditions.all?
  end
end
