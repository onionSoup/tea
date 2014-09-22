module AdminItemsHelper
  def destroy_items_confirm(item)
    if item.order_details.present?
      'この商品を注文している人がいます。本当に削除してもよろしいですか？'
    else
      '本当に削除してもよろしいですか？'
    end
  end
end
