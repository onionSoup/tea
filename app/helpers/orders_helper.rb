module OrdersHelper

  def item_name_price
  	arr = []
  	items = Item.all
  	items.each do |item|
      arr.push( item.name + "(" + item.price.to_s + "円" + ")" )
  	end
  	  return arr
  end

end
