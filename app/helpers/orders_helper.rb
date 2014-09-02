module OrdersHelper
  def item_options
    options_of_items = Item.all.map {|item| ["#{item.name}(#{item.price}円)", item.id] }
    options_with_blank = options_of_items.unshift(['', ''])
  end

  def quantity_options
    quantities = 1.. OrderDetail::MAX_QUANTITY_PER_ORDER

    [['', ''], *quantities.map]
  end

  #論理的にはこの２つの他、もう１つの分岐があるswitchのほうが正しい。
  #もう１つの分岐とはPeriod.disabledの時。PeriodNotice#showへのリンクを貼ることになる。
  #しかし、「注文をしたかったら、管理者が注文期限を設定するよう依頼してください」をリンクテキストの短さで表現できない。
  #そのため、一回このヘルパーが生成するリンクを踏ませる。そしてコントローラーでPeriodNotice#showに導く。
  def link_to_index_or_show(index_link_text, show_link_text)
    index_link = content_tag(:a, href: order_details_path) { "#{index_link_text}" }
    show_link  = content_tag(:a, href: order_path)         { "#{show_link_text}" }

    conditions_to_get_details_index ? index_link : show_link
  end
end
