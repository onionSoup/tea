module OrdersHelper
  def item_count
    arr =[]
    i = 0
    20.times do  # １人の人が、１種類のお茶に、注文できる最大数はとりあえず１９個としておく。
      arr << ( ["#{i}個", i] )
      i += 1
    end
    return arr
  end
end
