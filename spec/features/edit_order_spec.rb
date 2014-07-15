feature '既存の注文を修正する'do
  background do
    alice = create(:user, name: 'Alice')

    herb_tea = create(:item, name: 'herb_tea', price: 100)
    red_tea = create(:item, name: 'red_tea', price: 100)

    alice.order.update_attributes(
      order_details: [
        build(:order_detail, item: herb_tea, quantity: 1),
        build(:order_detail, item: red_tea, quantity: 1)
      ]
    )

    login_as 'Alice'
  end

  scenario '既存の注文明細がある場合、注文ページにいくと明細と合計金額が見れる' do
    expect(exist_tea_in_table? 'herb_tea').to be true
    expect(page.find(:css, '#edit_order_sum_yen').text).to eq '200円'
  end

  context 'さらに別のお茶を注文する場合' do
    background do
      create :item, name: 'green_tea', price: 100
      click_link '注文画面'
    end

    scenario '商品と個数を選んで「注文する」を押すと、表に明細が追加されて、メッセージも出る' do
      choose_item_and_quantity 'green_tea', 1
      click_button '注文する'

      expect(exist_tea_in_table? 'green_tea').to be true
      expect(page).to have_content 'green_teaを追加しました。'
    end

    scenario '品名だけを選んだ場合、注文はできない' do
      choose_item_and_quantity 'green_tea', ''
      click_button '注文する'

      expect(exist_tea_in_table? 'green_tea').to be false
      expect(page).to have_content '商品名と数量を両方指定して注文してください'
    end

    scenario '数量だけを選んだ場合、注文はできない' do
      choose_item_and_quantity '', 1
      click_button '注文する'

      expect(exist_tea_in_table? 'green_tea').to be false
      expect(page).to have_content '商品名と数量を両方指定して注文してください'
    end
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

  scenario '注文を追加した場合も、注文済み商品の合計金額が見れる' do
    create_user_and_login_as 'Bob'

    choose_item_and_quantity 'red_tea', 3
    click_button '注文する'

    choose_item_and_quantity 'herb_tea', 1
    click_button '注文する'

    expect(page.find(:css, '#edit_order_sum_yen').text).to eq '400円'
  end
end
