feature 'ネスレ発送待ち商品ページ' do
  scenario 'ネスレの発送を待っているお茶があるなら、商品名と注文合計金額が表示されている' do
    create_order 'ordered'
    visit '/orders/ordered'

    expect(page).to have_content 'アイスミント'
    expect(page).to have_content '紅茶'
    expect(page).to have_content '7560円'
  end

  scenario '何も注文されていないとき、ボタンを押しても移動しない' do
    visit '/orders/ordered'
    click_button 'お茶の受領をシステムに登録'

    expect(page.current_path).to eq '/orders/ordered'
  end

  scenario '注文があるとき、ボタンを押すとネスレ発送待ちページに移動して成功メッセージがでる' do
    create_order 'ordered'
    visit '/orders/ordered'
    click_button 'お茶の受領をシステムに登録'

    expect(page.current_path).to eq '/orders/arrived'
    expect(page).to have_content 'ネスレからお茶が届いたことを登録しました。'
    expect(page).to have_content 'アイスミント'
  end
end
