FactoryGirl.define do
  factory :order_detail do
    quantity  1
  end

  factory :order do
    trait :buyer do
      user
    end
  end
end
