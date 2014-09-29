module AdminItemsHelper
  def destroy_items_confirm(item)
    if item.order_details.present?
      'この商品を注文している人がいます。本当に削除してもよろしいですか？'
    else
      '本当に削除してもよろしいですか？'
    end
  end

  #TODO まだ「順番を変更しない」と直後のアイテムが同時に出る問題を解決する
  def item_order_options(items, item)
    options_of_items = items.map.with_index {|item, i| ["#{item.name}の前", i]}

    #不要だけどあえてreturnをつけて戻り値をわかりやすくする
    if item.new_record?
      return options_with_last = options_of_items.push(['一番最後', items.length])
    else
      renamed_options = rename_option_of_exist_item(options_of_items, item)
      unless items.last == item
        return renamed_options.push(['一番最後', items.length])
      else
        return renamed_options
      end
    end
  end

  def rename_option_of_exist_item(options_of_items, item)
    options_of_items[item.nestle_index_from_the_top][0] = "順番を変更しない"
    options_of_items
  end
end
