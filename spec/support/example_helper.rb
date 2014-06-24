module ExampleHelper
  def create_order(state)
    user = create(:user, name: 'Alice')
    ice_mint = create(:item, name: 'アイスミント', price: 756)
    red_tea = create(:item, name: '紅茶', price: 756)
    create(:order,
      user_id: user.id,
      state:   Order.states[state],
      order_details: [
        build(:order_detail, item_id: ice_mint.id, quantity: 1),
        build(:order_detail, item_id: red_tea.id, quantity: 9)
      ]
    )
  end

  def create_user_and_login_as(name)
    create :user, name: name
    login_as name
  end

  def login_as(name)
    visit '/sessions/new'
    fill_in 'ユーザー名', :with => name
    click_button 'ログイン'
  end

  #上から#{selecter_index +1 }番目のセレクタで商品#{item}を#{quantity}個選ぶ。
  def choose_item_quantity_at_nth_selector(item, quantity, selecter_index)
    select item, from: "order_order_details_attributes_#{selecter_index}_item_id"
    target = quantity.zero? ? '' : "#{quantity}個"
    select target, from: "order_order_details_attributes_#{selecter_index}_quantity"
  end

end
