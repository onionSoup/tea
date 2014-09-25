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
      '現在、注文期間が未設定です。ユーザーが注文できません。']
    when 'can_add_detail'
      [cart_position_names[1],
      "#{l Period.singleton_instance.end_time}まで注文期間中です。ユーザーが注文できます。"]
    when 'wait_ordered'
      [cart_position_names[2],
      '注文期間が終了しました。期間中にあったユーザーからの注文を、まだネスレに発注していません。']
    when 'nothing_added'
      [cart_position_names[6],
      '１人のユーザーも注文せずに注文期間が終了しました。']
    when 'ordered'
      [cart_position_names[3],
      '注文は発送されました。支社に届くのを待っています。']
    when 'arrived'
      [cart_position_names[4],
      '注文したお茶が支社に届きました。']
    when 'finish'
      [cart_position_names[5],
      "すべてのユーザーの引換が完了しました。<br>現在、ユーザーの注文を募集していません。"]
    else
      raise "bag in #{__method__}"
    end
    {title: explain[0], paragraph: explain[1]}
  end

  def admin_position_instruction
    cart_position_names = Order.admin_cart_position_names(nothing_added: true)
    explain = case Order.admin_status_with_period
    when 'undefined_period'
      "注文期間が設定されていないので、ユーザーの注文を受け付ていない状態です。<br>受け付けるには以下の手順で作業をすることを推奨します。
      <ol>
        <li>#{link_to '商品の管理ページ', admin_items_path }の商品が#{about_page_link(link_text: 'ネスレ')}のものと合っているか確認・修正します。</li>
        <li>#{link_to '送料の管理ページ', admin_postage_path }で送料と無料条件が#{shipping_cost_page_link(link_text: 'ネスレ')}のものと合っているか確認・修正します</li>
        <li>#{link_to '注文期間の管理ページ', admin_period_path }でボタンを押して、注文期間を新規設定します。<br>ユーザーからの注文を募集できるようになり、次の「注文待ち」に移ります。</li>
      </ol>"
    when 'can_add_detail'
      "管理者として、すべきことはありません。<br>ユーザーの注文は#{link_to 'ネスレ入力用ページ', registered_path}で確認できます。
      <p>注文期間が切れる#{l(Period.singleton_instance.end_time + 1.days)}以降は、「発注」または「注文なし」に移ります。</p>"
    when 'wait_ordered'
      "ネスレに発注をしてください。以下の手順で作業をすることを推奨します。
      <ol>
        <li>#{link_to 'ネスレ入力用ページ', registered_path}でユーザーの注文を確認します。</li>
        <li>注文しているユーザーにidobataで注文が間違っていないか、<br>確認を求めることを推奨します。（この作業は必須ではありません。）</li>
        <li>#{about_page_link(link_text: 'ネスレのサイト')}で注文します。</li>
        <li>#{link_to 'ネスレ入力用ページ', registered_path}でボタンを押して、発注したことを記録します。次の「発送待ち」に移ります。</li>
      </ol>"
    when 'nothing_added'
      "#{link_to '注文期間の削除', admin_period_path}をして新しく注文を受け付けることができます。<br>注文期限を削除すれば「期間設定」に移ります。"
    when 'ordered'
      "お茶が支社に届いた場合、#{link_to '発送待ち商品の確認ページ', ordered_path}でボタンを押してください。<br>引換ができるようになり、次の「引換」に移ります。"
    when 'arrived'
      "お茶とお金の引換ができます。以下の手順で作業ができます。
      <ol>
        <li>#{link_to '引換用ページ', arrived_path}で引換できるお茶とユーザーを確認してください。</li>
        <li>お金を受け取ってお茶を渡してください。（引換してください。）</li>
        <li>#{link_to '引換用ページ', arrived_path}で引換た人の分にチェックを入れ<br>ボタンを押して引換をシステムに記録してください。</li>
        <li>すべての人の分について、引換が終了すれば、次の「終了処理」に移ります。</li>
      </ol>"
    when 'finish'
      "#{link_to '注文期間の削除', admin_period_path}をして新しく注文を受け付けることができます。<br>
      注文期間の削除後は、「期間設定」に移ります。"
    else
      raise "bag in #{__method__}"
    end
  end
end
