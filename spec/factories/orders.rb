#このファクトリが存在する理由はまだ殆どない。
#しかし今後、quantity 1 のようなデフォルト値が増えていった場合、このファクトリの存在意義が出てくる。
FactoryGirl.define do
  factory :order_detail do
    quantity  1

    #trait or inheritanceで書き換え
    ignore do
      make_order false
    end

    after(:build) do |detail, evaluator|
      #ガード節で書きたいけど、breakはlocal jump errorになる
      if evaluator.make_order
        detail.item = create(:index_name_tea)
        order = create :order, order_details: [detail]
      end
    end
  end

  factory :order do
    user
  end

  factory :plain_order, class: Order do
  end
end
