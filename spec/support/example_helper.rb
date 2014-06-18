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

  def login_as(name)
    create :user, name: name
    visit '/sessions/new'
    fill_in 'ユーザー名', :with => name
    click_button 'ログイン'
  end
end