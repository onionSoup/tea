feature '引換済み商品' do
  context '引換後で、破棄していないお茶があるとき' do
    before do
      alice = create(:user, name: 'Alice')
      herb_tea = create(:item, name: 'herb_tea', price: 100)
      red_tea = create(:item, name: 'red_tea', price: 100)

      alice.order.update_attributes(
        state: 'exchanged',
        order_details: [
          OrderDetail.new(item: herb_tea, quantity: 1),
          OrderDetail.new(item: red_tea, quantity: 9)])
      login_as alice.name
    end

    scenario '商品名とユーザー名が表示されている' do
      visit '/orders/exchanged'

      expect(page).to have_content 'herb_tea'
      expect(page).to have_content 'red_tea'
      expect(page).to have_content 'Alice'
    end

    scenario '注文をチェックして登録ボタンを押す場合、ボタンを押す前にあった注文情報が消える' do
      visit '/orders/exchanged'

      expect(page).to have_content 'herb_tea'

      click_button 'このページの引換情報を削除'

      expect(page.current_path).to eq '/orders/exchanged'
      expect(page).to have_content '商品の削除が完了しました。'
      expect(page).not_to have_content 'アイスミント'
    end
  end

  scenario '何も商品がないとき、ボタンを押しても移動しない' do
    visit '/orders/exchanged'
    click_button 'このページの引換情報を削除'

    expect(page.current_path).to eq '/orders/exchanged'
  end
end

