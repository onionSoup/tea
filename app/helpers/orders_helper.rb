module OrdersHelper

  def item_name_price
    arr = []
    items = Item.all
    items.each do |item|
      arr << ( "#{item.name}(#{item.price}円)")
    end
      return arr
  end


  def item_count
    arr =[]
    i = 0
    20.times do  # １人の人が、１種類のお茶に、注文できる最大数はとりあえず１９個としておく。
      arr << ( ["#{i}個", i] )
      i += 1
    end
    return arr
  end

  #多分これ使わない
  def ignore_item_if_zero_quantity(params)
    params["order_details_attributes"].each do |attributes|
      if ( attributes["quantity"] == 0 )
      end
    end
  end

end
