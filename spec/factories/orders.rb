#このファクトリが存在する理由はまだ殆どない。
#しかし今後、quantity 1 のようなデフォルト値が増えていった場合、このファクトリの存在意義が出てくると思う。

FactoryGirl.define do
  factory :order_detail do
    quantity  1
    #check_order_details_numberのvalidationがあるorderは、先にorder_detailができてないと作れない。
    #そのため
    #order
    #というFactoryGirlで一般的に使う関連の方法が使えない。


    #after :build以下のコードを書いていただいた。これでorder_detailを作った時に、orderができる。
    #これで、check_order_details_numberのvalidationは突破できる。
    #ただしこれは以下のようなコード（こっちも書いて頂いた）と共存しない
    #すなわちorderを作るとき、同時にdetailもデフォルト値を上書きすることができない
    #create(:order,
    # order_details: [
    #   build(:order_detail, item_id: ice_mint.id, quantity: 1),
    # ]

    #書いて頂いたコード
    #after :build do |detail|
      #build :order, order_details: [detail]
    #end


    #例えば以下のようにして、order_detail作成時に一緒にorderを作りたい時だけcreate(:order_detail, make_order:true)とすれば、いいかもしれない。
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
    #例えば以下のようなテストを作った時、ちゃんと通る。
    #scenario 'order_create' do
    #  detail = create(:order_detail, make_order: true)
    #  expect(detail).to be_valid
    #  expect(detail.order).to be_valid
    #end
  end

  factory :order do
    user
    #このファクトリの定義が完了する前にorder_detailをつくって、このorderのidをいれることができれば、lintに通るファクトリができる。
  end
end
