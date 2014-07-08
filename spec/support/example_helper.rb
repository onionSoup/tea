module ExampleHelper
  def create_user_and_login_as(name)
    create :user, name: name
    login_as name
  end

  def login_as(name)
    visit '/sessions/new'
    fill_in 'ユーザー名', with: name
    click_button 'ログイン'
  end

  def choose_item_and_quantity(item,quantity)
    choose_item item
    choose_quantity quantity
  end

  #引数のお茶の名前が、明細票に表示されているならtrue、表示されてないならfalseを返す。
  def exist_tea_in_table?(tea_name)
    tea_names = page.all(:css, 'td.name').map(&:text)
    tea_names.include?(tea_name)
  rescue Capybara::ElementNotFound
    false
  end

  private

  #orders/edit.html.erbのセレクタボックスで商品を選ぶメソッド。
  #引数itemには、Item#name、itemオブジェクト、空白の文字列''のいずれかを渡せる。
  def choose_item(item)
    if item == ''
      select '', from: '品名：'
    else
      item_name = item.instance_of?(Item) ? item.name : item
      select item_name, from: '品名：'
    end
  end

  #orders/edit.html.erbのセレクタボックスで個数を選ぶメソッド。
  #引数quantityには、OrderDetail#quantity、空白の文字列''のいずれかを渡せる。
  def choose_quantity(quantity)
    if quantity == ''
      select '', from: '数量：'
    else
      quantity_with_unit = "#{quantity}個"
      select quantity_with_unit, from: '数量：'
    end
  end

  #引数userのorderが、state == registeredの時。管理者用ページの一連のボタンを踏んでstateを更新し、最後には削除ボタンを押す。
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
