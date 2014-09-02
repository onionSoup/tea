module OrdersHelper
  def item_options
    options_of_items = Item.all.map {|item| ["#{item.name}(#{item.price}円)", item.id] }
    options_with_blank = options_of_items.unshift(['', ''])
  end

  def quantity_options
    quantities = 1.. OrderDetail::MAX_QUANTITY_PER_ORDER

    [['', ''], *quantities.map]
  end

  def link_to_index_or_show(index_link_text, show_link_text)
    index_link  = content_tag(:a, href: order_details_path) { "#{index_link_text}" }
    show_link   = content_tag(:a, href: order_path)         { "#{show_link_text}" }
    period_link = content_tag(:a, href: period_notice_path) { "#{index_link_text}" } #これはミスではない。リンクテキストは使いまわす。

    return period_link unless Period.enabled?
    return show_link   unless Period.include_now?
    return show_link   unless current_user.order.registered?

    index_link
  end
end
