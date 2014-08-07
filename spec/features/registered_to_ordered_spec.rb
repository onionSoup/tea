feature 'ネスレ入力用シート' do
  context '注文があるとき' do
    before do
      alice = create(:user, name: 'Alice')

      herb_tea = create(:item, name: 'herb_tea', price: 100)
      red_tea = create(:item, name: 'red_tea', price: 100)

      alice.order.update_attributes(
        order_details: [
          build(:order_detail, item: herb_tea, quantity: 1),
          build(:order_detail, item: red_tea, quantity: 9)
        ]
      )

      visit '/orders/registered'
    end

    scenario '商品名と注文合計金額が表示されている' do
      expect(page).to have_content 'herb_tea'
      expect(page).to have_content '1000円' #これのためfixtureを使わない
    end

    scenario 'ユーザーごとの詳細が見れる' do
      table_of_order_by_user = page.find('.admin_order_table.users_table_in_admin_orders_pages')

      expect(table_of_order_by_user).to have_content 'Alice'
      expect(table_of_order_by_user).to have_content 'herb_tea'
      expect(table_of_order_by_user).to have_content '1000'
    end

    scenario '注文完了登録ボタンを押すと、ネスレ発送待ちページに移動して成功メッセージがでる' do
      click_button '注文の完了をシステムに登録'

      expect(page.current_path).to eq '/orders/ordered'
      expect(page).to have_content 'ネスレ公式へ注文したことを登録しました。'
      expect(page).to have_content 'herb_tea'
    end
  end

  scenario '何も注文されていないとき、ボタンを押しても移動しない' do
    visit '/orders/registered'
    click_button '注文の完了をシステムに登録'

    expect(page.current_path).to eq '/orders/registered'
  end
end
