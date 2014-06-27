feature '引換用ページ' do
  background do
    create_alice_and_default_order 'arrived'
    visit '/orders/arrived'
  end

  scenario '引換してない商品があるなら、商品名とユーザー名が表示されている' do
    expect(page).to have_content 'アイスミント'
    expect(page).to have_content '紅茶'
    expect(page).to have_content 'Alice'
  end

  scenario '何もチェックを入れないとき、ボタンを押しても移動しない' do
    click_button '引換の完了をシステムに登録'

    expect(page.current_path).to eq '/orders/arrived'
  end

  scenario '注文をチェックして登録ボタンを押す場合、引換済みページに移動して成功メッセージがでる' do
    #これが良くない。しかし、後々１ユーザー１オーダーにした際には、userのラベルからcheckboxを特定できるようになる。
    check "#{idsafe_encode64 'Alice'}"
    click_button '引換の完了をシステムに登録'

    expect(page.current_path).to eq '/orders/exchanged'
    expect(page).to have_content '引換したことを登録しました。'
    expect(page).to have_content 'Alice'
  end
end

