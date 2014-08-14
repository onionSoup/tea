feature '発送待ち商品の確認' do
  context 'ネスレの発送を待っているお茶があるとき' do
    before do
      alice = create(:user, name: 'Alice')

      herb_tea = create(:item, name: 'herb_tea', price: 100)
      red_tea = create(:item, name: 'red_tea', price: 100)

      alice.order.update_attributes(
        state: 'ordered',
        order_details: [
          build(:order_detail, item: herb_tea, quantity: 1),
          build(:order_detail, item: red_tea,  quantity: 9)
        ]
      )

      login_as 'Alice'
    end
    scenario 'ページにアクセスすると商品名と注文合計金額が表示されている' do
      visit '/orders/ordered'

      expect(page).to have_content 'herb_tea'
      expect(page).to have_content '1000円' #これのためfixturesを使わない
    end

    scenario 'ページにアクセスすると、ユーザーごとの詳細が見れる' do
      visit '/orders/ordered'
      table_of_order_by_user = page.find('.admin_order_table.users_table_in_admin_orders_pages')

      expect(table_of_order_by_user).to have_content 'Alice'
      expect(table_of_order_by_user).to have_content 'herb_tea'
      expect(table_of_order_by_user).to have_content '1000'
    end


    scenario 'ボタンを押すとネスレ発送待ちページに移動して成功メッセージがでる' do
      visit '/orders/ordered'
      click_button 'お茶の受領をシステムに登録'

      expect(page.current_path).to eq '/orders/arrived'
      expect(page).to have_content 'ネスレからお茶が届いたことを登録しました。'
      expect(page).to have_content 'herb_tea'
    end
  end

  scenario 'ネスレの発送を待っているお茶がないとき、ボタンが表示されない。' do
    visit '/orders/ordered'

    expect(page).not_to have_button 'お茶の受領をシステムに登録'
  end
end
