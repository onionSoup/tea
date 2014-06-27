feature 'ネスレ入力用シート' do
  context '注文があるとき' do
    before do
      alice = create(:user, name: 'Alice')
      herb_tea = create(:item, name: 'herb_tea', price: 100)
      red_tea = create(:item, name: 'red_tea', price: 100)
      alice.order.order_details << OrderDetail.new(item: herb_tea, quantity: 1)
      alice.order.order_details << OrderDetail.new(item: red_tea, quantity: 9)
      visit '/orders/registered'
    end

    scenario 'ネスレ入力用シートに来た時、注文があるなら、商品名と注文合計金額が表示されている' do
      expect(page).to have_content 'herb_tea'
      expect(page).to have_content '1000円'
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
