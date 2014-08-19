module OrdersHelper
  def item_options
    options_of_items = Item.all.map {|item| ["#{item.name}(#{item.price}円)", item.id] }
    options_with_blank = options_of_items.unshift(['', ''])
  end

  def quantity_options
    quantities = 1.. OrderDetail::MAX_QUANTITY_PER_ORDER

    [['', ''], *quantities.map]
  end

  #link_to_details_index_or_order_showだと長い。
  def link_to_index_or_show(index_link_text, show_link_text)
    if current_user.order.registered?
      content_tag(:a, href: order_details_path) { "#{index_link_text}" }
    else
      content_tag(:a, href: order_path)         { "#{show_link_text}" }
    end
  end
end
