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

  #orders/edit.html.erbのセレクタボックスで、引数で指定した通り、商品とその個数を選ぶ。
  #引数itemには、Item#name、itemオブジェクト、空白の文字列''のいずれかを渡せる。
  #引数quantityには、1..MAX_NUMBER_OF_QUANTITY_OF_ONE_DETAILまでの数字、または空白の文字列''を渡せる。
  def choose_item_and_quantity(item,quantity)
    choose_item item
    choose_quantity quantity
  end

  #引数のお茶の名前が、明細票に表示されているならtrue、表示されてないならfalseを返す。
  #have_contentだと、「明細票に表示されてないがselect boxにはある」という場合でもtrueを返してしまうため、
  #このメソッドが必要になる。
  def exist_tea_in_table?(tea_name)
    exception = nil
    begin
      found_tea_names = page.all(:css, 'td.name').map {|elm| elm.text }
    rescue => exception
    end
    !exception && found_tea_names.include?(tea_name)
  end

  private

  #引数はItemのインスタンスか、商品名。両方の場合でitemを返す。
  def find_item_object_from(obj_or_name)
    begin
      item_obj= obj_or_name.instance_of?(Item) ? obj_or_name : Item.find_by_name!(obj_or_name)
    rescue
      #上で例外が発生するなら終了させたい。これを書かないと、どこかでキャッチすると読み手が思うかもしれないので一応書いてみる。
      abort "choose_item_and_quantityの第１引数は商品名か、Itemオブジェクトか、空白文字列''である必要があります。"
    end
  end

  #orders/edit.html.erbのセレクタボックスで商品を選ぶメソッド。
  #引数itemには、Item#name、itemオブジェクト、空白の文字列''のいずれかを渡せる。
  def choose_item(item)
    blank_item = item if item == '' #万一 itemに[]などが渡された時 == ''じゃなくてempty?だと困る。
    select blank_item , from: '品名：' and return if blank_item

    item_obj = find_item_object_from(item)
    item_with_price = "#{item_obj.name}(#{item_obj.price}円)"

    select item_with_price, from: '品名：'
  end

  def choose_quantity(quantity)
    blank_quantity = quantity if quantity == ''
    select blank_quantity , from: '数量：' and return if blank_quantity

    quantity_with_unit = "#{quantity}個"
    select quantity_with_unit, from: '数量：'
  end
end
