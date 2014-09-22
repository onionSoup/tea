module AdminItemsHelper
  def destroy_items_confirm(item)
    if item.order_details.present?
      'この商品を注文している人がいます。本当に削除してもよろしいですか？'
    else
      '本当に削除してもよろしいですか？'
    end
  end

  def item_order_options(items)
    options_of_items   = items.map.with_index {|item, i| ["#{item.name}の前", i]}
    options_with_blank = options_of_items.push(['一番最後', items.length])
  end
end
