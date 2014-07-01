feature '既存の注文を修正する'do
  background do
    alice = create(:user, name: 'Alice')

    #priceをexpectationで使うので,fixturesは使わない。
    herb_tea = create(:item, name: 'herb_tea', price: 100)
    red_tea = create(:item, name: 'red_tea', price: 100)

    alice.order.update_attributes(
      order_details: [
        build(:order_detail, item: herb_tea),
        build(:order_detail, item: red_tea)
      ]
    )

    login_as 'Alice'
  end

  scenario '既存の注文明細がある場合、注文ページにいくと明細が表示されている' do
    expect(exist_tea_in_table? 'herb_tea').to be true
  end

  scenario '商品と個数を選んで「注文する」を押すと、表に明細が追加されて、メッセージも出る' do
    #green_teaを選んで明細票に出す前処理。
    create :item, name: 'green_tea', price: 100
    click_link '注文画面'

    #商品と個数を選んで注文する。
    choose_item_and_quantity 'green_tea', 1
    click_button '注文する'

    expect(exist_tea_in_table? 'green_tea').to be true
    expect(page).to have_content 'green_teaを追加しました。'
  end

  #TODO: 追加済みのお茶は、選択肢を出さなくしたほうが良い
  scenario '明細表にあるお茶をさらに追加しようとすると、エラーになる' do
    expect(exist_tea_in_table? 'herb_tea').to be true

    choose_item_and_quantity 'herb_tea', 1

    click_button '注文する'

    expect(page).to have_content 'その商品は既に注文しています。'
  end

  scenario '明細の横の「削除する」リンクを押すと、表から明細が削除されて、通知がある' do
    herb_tea_id = OrderDetail.find_by_item_id(Item.find_by_name('herb_tea')).id
    find("#destroy_detail#{herb_tea_id}").click

    expect(exist_tea_in_table? 'herb_tea').to be false
    expect(page).to have_content 'herb_teaの注文を削除しました。'
  end

  scenario '品名と量を選ぶと、合計金額が見れる' do
    create_user_and_login_as 'Bob'

    choose_item_and_quantity 'red_tea', 3
    click_button '注文する'

    choose_item_and_quantity 'herb_tea', 1
    click_button '注文する'

    expect(page).to have_content '400円'
  end
end
