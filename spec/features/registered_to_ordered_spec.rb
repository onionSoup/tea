feature 'ネスレ入力用シート' do
  scenario 'ネスレ入力用シートに来た時、注文があるなら、商品名と注文合計金額が表示されている' do
    create_order('registered')
    visit '/orders/registered'
    expect(page).to have_content('アイスミント')
    expect(page).to have_content('紅茶')
    expect(page).to have_content('7560円')
  end

  scenario '何も注文されていないとき、ボタンを押しても移動しない' do
    visit '/orders/registered'

    click_button '注文の完了をシステムに登録'

    expect(page.current_path).to eq('/orders/registered')
  end

  scenario '注文があるとき、ボタンを押すとネスレ発送待ちページに移動する' do
    create_order('registered')
    visit '/orders/registered'

    click_button '注文の完了をシステムに登録'

    expect(page.current_path).to eq('/orders/ordered')
  end
end
