module NestleUrlsHelper
  URLS = {
  cost_page: 'https://shop.nestle.jp/front/app/info/help/#guide_midashi04',
  about_page: 'https://shop.nestle.jp/front/app/cart/collect_cart/init/00000000/SpecialTCapsule/'
  }

  def shipping_cost_page_link(link_text: '送料のページ')
    link_to(link_text, URLS[:cost_page])
  end

  def about_page_link
    link_to('ネスレの通販ページ', URLS[:about_page])
  end

end
