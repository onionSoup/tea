feature '引換用ページ' do
  background do
      alice = create(:user, name: 'Alice')
      herb_tea = create(:item, name: 'herb_tea', price: 100)
      red_tea = create(:item, name: 'red_tea', price: 100)

      alice.order.update_attributes(
        state: 'arrived',
        order_details: [
          OrderDetail.new(item: herb_tea, quantity: 1),
          OrderDetail.new(item: red_tea, quantity: 9)])
      login_as alice.name

    visit '/orders/arrived'
  end

  scenario '引換してない商品があるなら、商品名とユーザー名が表示されている' do
    expect(page).to have_content 'herb_tea'
    expect(page).to have_content 'red_tea'
    expect(page).to have_content 'Alice'
  end

  scenario '何もチェックを入れないとき、ボタンを押しても移動しない' do
    click_button '引換の完了をシステムに登録'

    expect(page.current_path).to eq '/orders/arrived'
  end

  scenario '注文をチェックして登録ボタンを押す場合、引換済みページに移動して成功メッセージがでる' do
    alice = User.find_by_name('Alice')
    check "user_#{alice.id}"
    click_button '引換の完了をシステムに登録'

    expect(page.current_path).to eq '/orders/exchanged'
    expect(page).to have_content '引換したことを登録しました。'
    expect(page).to have_content 'Alice'
  end
end

