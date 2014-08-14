module ApplicationHelper
  def path_to_admin_user_detail(user_id, detail_id)
    "/admin/users/#{user_id}/order_details/#{detail_id}:id"
  end

  def shipping_cost_page_link(japanese_explain)
    link_to(
      japanese_explain,
      'https://shop.nestle.jp/front/app/info/help/#guide_midashi04'
    )
  end
  def nestle_shopping_site_link(text)
    link_to(
      text,
      'https://shop.nestle.jp/front/app/cart/collect_cart/init/00000000/SpecialTCapsule/'
    )
  end
end
