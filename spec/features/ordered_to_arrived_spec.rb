feature 'ネスレ発送待ち商品ページ' do
  context '注文があるとき' do
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

    scenario 'ネスレの発送を待っているお茶があるなら、商品名と注文合計金額が表示されている' do
      visit '/orders/ordered'

      expect(page).to have_content 'herb_tea'
      expect(page).to have_content '1000円' #これのためfixturesを使わない
    end

    scenario '注文があるとき、ボタンを押すとネスレ発送待ちページに移動して成功メッセージがでる' do
      visit '/orders/ordered'
      click_button 'お茶の受領をシステムに登録'

      expect(page.current_path).to eq '/orders/arrived'
      expect(page).to have_content 'ネスレからお茶が届いたことを登録しました。'
      expect(page).to have_content 'herb_tea'
    end
  end

  scenario '何も注文されていないとき、ボタンを押しても移動しない' do
    visit '/orders/ordered'
    click_button 'お茶の受領をシステムに登録'

    expect(page.current_path).to eq '/orders/ordered'
  end
end
