# == Schema Information
#
# Table name: order_details
#
#  id         :integer          not null, primary key
#  order_id   :integer
#  item_id    :integer
#  quantity   :integer
#  created_at :datetime
#  updated_at :datetime
#

class OrderDetail < ActiveRecord::Base
  belongs_to :order
  belongs_to :item

  #量が０のものは、保存したくない。ただこれだとOrderを作るとき、一緒に０以上のものがあっても保存されなくなってしまう。
  #validates :quantity, numericality: { greater_than: 0 }
end
