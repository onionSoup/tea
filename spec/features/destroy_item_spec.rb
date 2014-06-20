feature '商品の削除' do
  def create_order_of_herb_tea
    item = create(:item, name: 'herb_tea')
    create :order, order_details: [build(:order_detail, item_id: item.id)]
  end

  scenario '削除リンクを押せば、既存の商品を削除できる' do
    create :item, name: 'herb_tea', price: 756
    visit '/admin/items'

    expect(page).to have_content 'herb_tea'
    click_link 'destroy_0th_item'

    expect(page).not_to have_content 'herb_tea'
  end

  scenario '商品Aを含む注文情報がある場合、商品Aは削除できない' do
    create_order_of_herb_tea
    visit '/admin/items'
    click_link 'destroy_0th_item'

    expect(page).to have_content 'この商品を使った注文情報があるので、削除できません。'
    expect(page). to have_content 'herb_tea'
  end

  scenario '商品Aを含む注文情報を削除すれば、商品Aを削除できる。' do
    create_user_and_login_as 'Alice'
    create_order_of_herb_tea
    visit '/admin/items'

    #管理者用ページで注文の状態を更新していき、注文情報を削除する。
    click_link '管理者用'
    click_button '注文の完了をシステムに登録'
    click_button 'お茶の受領をシステムに登録'
    check 'checkbox_no_0'
    click_button '引換の完了をシステムに登録'
    click_button 'このページの引換情報を削除'

    #商品管理ページで、herb_teaを削除する。
    click_link '商品の管理'
    click_link 'destroy_0th_item'

    expect(page).not_to have_content 'herb_tea'
  end
end
