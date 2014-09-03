module ExampleHelper
  def create_user_and_login_as(name)
    create :user, name: name
    login_as name
  end

  def login_as(name)
    visit '/login'
    fill_in 'ユーザー名', with: name
    click_button 'ログイン'
  end

  def choose_item_and_quantity(item,quantity)
    choose_item item
    choose_quantity quantity
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
    fill_in "数量", with: "#{quantity}" unless quantity == ''
  end

  #引数userのorderが、state == registeredの時。管理者用ページの一連のボタンを踏んでstateを更新し、最後には削除ボタンを押す。
  def form_visiting_registered_to_delete_exchanged_of(user)
    raise 'user must have order whose state is registered' unless user.order.registered?

    click_link '管理者用'

    click_button '注文の完了をシステムに登録'

    click_button 'お茶の受領をシステムに登録'

    check ActionView::RecordIdentifier.dom_id user
    click_button '引換の完了をシステムに登録'

    click_button 'このページの引換情報を削除'
  end

  #TODO 以下２つはUIからやれるようにする。
  def make_deadline_from_now_to_next_week
    Period.singleton_instance.update_attributes!(
      begin_time: Time.zone.now.in_time_zone('Tokyo').at_beginning_of_day,
      end_time:   Time.zone.now.in_time_zone('Tokyo').next_week.at_end_of_day
    )
  end
end
