module ExampleHelper
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
    item_obj= obj_or_name.instance_of?(Item) ? obj_or_name : Item.find_by_name!(obj_or_name)
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

  #orders/edit.html.erbのセレクタボックスで個数を選ぶメソッド。
  #引数quantityには、OrderDetail#quantity、空白の文字列''のいずれかを渡せる。
  def choose_quantity(quantity)
    blank_quantity = quantity if quantity == ''
    select blank_quantity , from: '数量：' and return if blank_quantity

    quantity_with_unit = "#{quantity}個"
    select quantity_with_unit, from: '数量：'
  end

  #引数userのorderが、state= registeredの時。管理者用ページの一連のボタンを踏んで
  #stateを更新し、最後には削除ボタンを押す。
  def form_visiting_registered_to_delete_exchanged_of(user)
    raise 'user must have order whose state is regisetered' unless user.order.state == 'registered'

    click_link '管理者用'

    click_button '注文の完了をシステムに登録'

    click_button 'お茶の受領をシステムに登録'

    check "user_#{user.id}"
    click_button '引換の完了をシステムに登録'

    click_button 'このページの引換情報を削除'
  end
end
