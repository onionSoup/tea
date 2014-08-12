module ApplicationHelper
  def path_to_admin_user_detail(user_id, detail_id)
    "/admin/users/#{user_id}/order_details/#{detail_id}:id"
  end

  def registered?(user)
    user.order.state == 'registered'
  end

  def shipping_cost_page_link(japanese_explain)
    link_to japanese_explain, 'https://shop.nestle.jp/front/app/info/help/#guide_midashi04'
  end
end
