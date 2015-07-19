module StatusBarHelper
  def user_cart_position(order)
    case order.status_with_period
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
    when 'exchanged'
      5
    else
      raise "bag in #{__method__}"
    end
  end

  #TODO /orderのテストを直し始める時に一緒に消す
  def user_position_explain(order)
     cart_position_names = order.cart_position_names(nothing_added: true)
     explain = case order.status_with_period
     when 'undefined_period'
       [cart_position_names[0],
       '管理者が注文期間を設定して、注文の募集を始めるのを待っています。']
     when 'can_add_detail'
       [cart_position_names[1],
     '注文ができます。<br>フォームから欲しいお茶の品名と個数を選んで追加・削除してください。']
     when 'wait_ordered'
       [cart_position_names[2],
       '管理者がネスレに発注する（ネスレから購入する）のを待っています。']
     when 'nothing_added'
       [cart_position_names[6],
       '注文をせずに注文期間が終了しました。<br>管理者が次回の注文を募集するまでお待ちください。']
     when 'ordered'
       [cart_position_names[3],
       '注文は発送されました。支社に届くのを待っています。']
     when 'arrived'
       [cart_position_names[4],
       '注文したお茶が支社に届きました。<br>管理者にお金を渡してお茶を受け取れます。']
     when 'exchanged'
       [cart_position_names[5],
       '引換が完了しました。<br>管理者が次回の注文を募集するまでお待ちください。']
     else
       raise "bag in #{__method__}"
     end
     {title: explain[0], paragraph: explain[1]}
  end

  def user_position_title(order)
    cart_position_names = order.cart_position_names(nothing_added: true)
    explain = case order.status_with_period
    when 'undefined_period'
      cart_position_names[0]
    when 'can_add_detail'
      cart_position_names[1]
    when 'wait_ordered'
      cart_position_names[2]
    when 'nothing_added'
      cart_position_names[6]
    when 'ordered'
      cart_position_names[3]
    when 'arrived'
      cart_position_names[4]
    when 'exchanged'
      cart_position_names[5]
    else
      raise "bag in #{__method__}"
    end
  end

  def user_position_instruction(order)
    explain = case order.status_with_period
    when 'undefined_period'
      <<-"EOS".strip_heredoc
      管理者が注文期間を設定して、注文の募集を始めるのを待っています。<br>
      <p>注文期間が注文期間を設定することで、注文の状況が次の「注文可能」に移ります。</p>
      EOS
    when 'can_add_detail'
      <<-"EOS".strip_heredoc
      注文期限の#{l(Period.singleton_instance.end_time)}まで注文ができます。<br>
      注文は#{link_to '注文画面', order_path}で行います。<br>
      <p>
        #{l(Period.singleton_instance.end_time + 1.days)}深夜0時に注文が確定し、変更ができなくなります。<br>
        同時に注文の状況が以下のように変化します。<br>
        <div class="after_can_add_detail">
          <div>・お茶を注文している場合</div>
          <div>・お茶を注文していない場合</div>
        </div>
        <div class="after_can_add_detail">
          <div>「発送待ち」に移ります。</div>
          <div>「注文なし」に移ります。</div>
        </div>
      </p>
      EOS
    when 'nothing_added'
      <<-"EOS".strip_heredoc
      お茶を注文をせずに注文期間が終了しました。<br>
      管理者が終了処理を行うのを待っています。<br>
      <p>管理者が終了処理を行うと、注文の状況は「募集待ち」になります。</p>
      EOS
    when 'ordered'
      <<-"EOS".strip_heredoc
      お茶が発注されました。支社に届くのを待っています。<br>
      <p>お茶が届くと、注文の状況が次の「引換可能」に移ります。</p>
      EOS
    when 'arrived'
      <<-"EOS".strip_heredoc
      注文したお茶が支社に届きました。<br>
      管理者にお金を渡してお茶を受け取れます。<br>
      <p>お茶とお金の交換が終わると、注文の状況が次の「引換済み」に移ります。</p>
      EOS
    when 'exchanged'
      <<-"EOS".strip_heredoc
      引換が完了しました。ご注文ありがとうございました。<br>
      管理者が終了処理を行うのを待っています。<br>
      <p>管理者が終了処理を行うと、注文の状況は「募集待ち」になります。</p>
      EOS
    else
      raise "bag in #{__method__}"
    end
  end
end
