class Order < ActiveRecord::Base
  has_many :order_details
  belongs_to :user
end
