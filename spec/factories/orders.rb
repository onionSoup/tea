#このファクトリが存在する理由はまだ殆どない。
#しかし今後、quantity 1 のようなデフォルト値が増えていった場合、このファクトリの存在意義が出てくると思う。

FactoryGirl.define do
  factory :order_detail do
    quantity  1

    ignore do
      make_order false
    end

    after(:build) do |detail, evaluator|
      #ガード節で書きたいけど、breakはlocal jump errorになる
      if evaluator.make_order
        #関連に直接入れられる
        detail.item = create(:index_name_tea)
        order = create :order, order_details: [detail]
      end
    end
  end

  factory :order do
    user
  end
end
