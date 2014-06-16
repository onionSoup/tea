FactoryGirl.define do
  factory :order_detail do
    item
    quantity 1
  end

  factory :order do
    order_detail
  end
end
