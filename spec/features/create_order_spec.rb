#to do factory girl
feature '注文作成' do
  background do
    ICE_MINT_PRICE = 756
    Item.create name: 'アイスミント', price: ICE_MINT_PRICE
    #ログインする。
    User.create name: 'Bob'
    visit new_session_path
    fill_in 'sessions_name' , :with => 'Bob'
    click_button 'ログイン'
  end

  let(:choose_one_ice_mint) do
    page.select "アイスミント(#{ICE_MINT_PRICE}円)", :from => 'order_order_details_attributes_0_item_id'
    page.select '1個', :from => 'order_order_details_attributes_0_quantity'
  end

  scenario '何も選択せずに注文ボタンを押すと、同じ画面に' do
    click_button '注文を確定する'
    #expect(page.current_path).to eq(orders_path)だと、 POST /ordersのrenderでも通ってしまう
    expect(page).to have_content('注文を確定する')
  end

  scenario '品名と量を選ぶと、合計金額が見れる' do
    choose_one_ice_mint
    expect(page).to have_content("合計: #{ICE_MINT_PRICE * 1 }円")
  end


  scenario '品名と量を指定して注文すると注文ができて、注文確認画面にいく' do
    choose_one_ice_mint
    click_button '注文を確定する'
    expect(page).to have_content('ご注文の確認')
  end
end
