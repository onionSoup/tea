feature '既存の注文を修正する'do
  background do
    alice = create(:user, name: 'Alice')
    herb_tea = create(:item, name: 'herb_tea')
    alice.order.order_details << OrderDetail.new(item: herb_tea, quantity: 1)
    login_as('Alice')
  end

  scenario '既存の注文明細がある場合、注文ページにいくと明細が表示されている' do
  end

  scenario '商品と個数を選んで追加を押すと、表に明細が追加される' do
  end

  scenario '明細の横の「削除する」リンクを押すと、表から明細が削除される' do
  end
end
