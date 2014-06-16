module ExampleHelper
  def create_order(state)
    user = create :user, name: 'Alice'
    ice_mint = create :item, name: 'アイスミント', price: 756
    red_tea = create :item, name: '紅茶', price: 756

    #Factoryでやる
    order = Order.new(user_id: user.id, state: Order.states[state])
    order.order_details.build item_id: ice_mint.id, quantity: 1, order_id: order.id
    order.order_details.build item_id: red_tea.id, quantity: 9, order_id: order.id
    order.save
    order
  end

  def login_as(name)
    create(:user, name: name)
    visit '/sessions/new'
    fill_in 'ユーザー名', :with => name
    click_button 'ログイン'
  end
end
