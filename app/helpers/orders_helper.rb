module OrdersHelper
  def item_options
    options_of_existing_item = Item.all.map {|item| ["#{item.name}(#{item.price}円)", item.id] }
    options_with_blank = options_of_existing_item.unshift(['', ''])
  end

  def quantity_options
    (1..OrderDetail::MAX_NUMBER_OF_QUANTITY_OF_ONE_DETAIL).map {|i| ["#{i}個", i] }.unshift(['', ''])
  end

  def title_of_edit_order
    valid_details = current_user.order.order_details.reject {|detail| detail.invalid? }
    valid_details.any? ? '既存注文の修正' : '新規注文の作成'
  end
end
