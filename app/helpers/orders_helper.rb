module OrdersHelper
  def item_options
    #説明のため変数を用意してみたが、不要かも
    options_of_existing_item = Item.all.map {|item| ["#{item.name}(#{item.price}円)", item.id] }
    options_with_blank = options_of_existing_item.unshift(['', ''])
  end

  def quantity_options
    (1..19).map {|i| ["#{i}個", i] }.unshift(['', ''])
  end
end
