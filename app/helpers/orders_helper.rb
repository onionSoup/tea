module OrdersHelper

  def item_name_price
  	arr = []
  	items = Item.all
  	items.each do |item|
      arr.push( item.name + "(" + item.price.to_s + "円" + ")" )
  	end
  	  return arr
  end


  def item_count
    arr =[]
    i = 0
    20.times do  # １人の人が、１種類のお茶に、注文できる最大数はとりあえず１９個としておく。
      arr.push( [i.to_s + "個", i] )
      i += 1
    end
    return arr
  end

  def ignore_item_if_zero_quantity(params)
    size = params["order_details_attributes"].size

    params["order_details_attributes"].each_with_index  do |attributes,i|
      if ( attributes["#{i}"]["quantity"] == 0 )
      end
    end
  end

end
