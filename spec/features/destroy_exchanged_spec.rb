feature '引換済み商品' do
  scenario '引換後の商品（破棄していない）があるなら、商品名とユーザー名が表示されている' do
    create_order 'exchanged'
    visit '/orders/exchanged'

    expect(page).to have_content 'アイスミント'
    expect(page).to have_content '紅茶'
    expect(page).to have_content 'Alice'
  end

  scenario '何も商品がないとき、ボタンを押しても移動しない' do
    visit '/orders/exchanged'
    click_button 'このページの引換情報を削除'

    expect(page.current_path).to eq '/orders/exchanged'
  end

  scenario '注文をチェックして登録ボタンを押す場合、ボタンを押す前にあった注文情報が消える' do
    create_order 'exchanged'
    visit '/orders/exchanged'

    expect(page).to have_content 'Alice'

    click_button 'このページの引換情報を削除'

    expect(page.current_path).to eq '/orders/exchanged'
    expect(page).to have_content '商品の削除が完了しました。'
    expect(page).not_to have_content 'Alice'
  end
end

