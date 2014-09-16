module AdminStatusBarHelper
  def admin_cart_position
    case Order.admin_status_with_period
    when 'undefined_period'
      0
    when 'can_add_detail'
      1
    when 'wait_ordered'
      2
    when 'nothing_added'
      return 'not_a_number. cart is in second line'
    when 'ordered'
      3
    when 'arrived'
      4
    when 'finish'
      5
    else
      raise "bag in #{__method__}"
    end
  end

  def admin_position_explain
    cart_position_names = Order.admin_cart_position_names(nothing_added: true)
    explain = case Order.admin_status_with_period
    when 'undefined_period'
      [cart_position_names[0],
      "#{link_to '注文期間の設定', admin_period_path}をしてください。<br>注文期間を設定することで、ユーザーからの注文を募集でき、次の「注文待ち」に移ります。"]
    when 'can_add_detail'
      [cart_position_names[1],
    "ユーザーが注文できます。<br>ユーザーの注文は#{link_to 'ネスレ入力用ページ', registered_path}で確認できます。<p>注文期間が切れる#{l(Period.singleton_instance.end_time + 1.days)}以降は、「発注」または「注文なし」に移ります。</p>"]
    when 'wait_ordered'
      [cart_position_names[2],
      "ネスレに発注ができます。<br>#{link_to 'ネスレ入力用ページ', registered_path}で確認できるユーザーの注文を、#{about_page_link}で注文してください。<br>発注後、#{link_to 'ネスレ入力用ページ', registered_path}でボタンを押せば、次の「発送待ち」に移ります。
        "]
    when 'nothing_added'
      [cart_position_names[6],
      "１人のユーザーも注文せずに注文期間が終了しました。<br>#{link_to '注文期間の削除', admin_period_path}をして新しく注文を受け付けることができます。"]
    when 'ordered'
      [cart_position_names[3],
      '注文は発送されました。支社に届くのを待っています。']
    when 'arrived'
      [cart_position_names[4],
      "注文したお茶が支社に届きました。<p>引換を完了していないユーザーがいます。<br>お金を渡してお茶を受け取ってください。</p>その後、#{link_to '引換用ページ', arrived_path}で引換したことをシステムに記録してください。"]
    when 'finish'
      [cart_position_names[5],
      "すべてのユーザーの引換が完了しました。<br>現在
      、ユーザーの注文を募集していません。<br>#{link_to '注文期間の削除', admin_period_path}をして新しく注文を受け付けることができます。"]
    else
      raise "bag in #{__method__}"
    end
    {title: explain[0], paragraph: explain[1]}
  end
end
