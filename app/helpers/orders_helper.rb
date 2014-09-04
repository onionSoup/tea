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
    period_link = content_tag(:a, href: period_notice_path) { "#{index_link_text}" } #これはミスではない。リンクテキストは使いまわす。
    show_link   = content_tag(:a, href: order_path)         { "#{show_link_text}" }


    return period_link if Period.has_undefined_times?

    if Period.out_of_date?
      return index_link if current_user.order.registered? && current_user.order.order_details.empty?
      return show_link
    end

    index_link
  end
end
