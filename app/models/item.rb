# == Schema Information
#
# Table name: items
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  price      :integer
#  created_at :datetime
#  updated_at :datetime
#

class Item < ActiveRecord::Base
  has_many :order_details

  def self.item_count
    arr =[]
    i = 0
    20.times do  # １人の人が、１種類のお茶に、注文できる最大数はとりあえず１９個としておく。
      arr << ( ["#{i}個", i] )
      i += 1
    end
    return arr
  end
end
