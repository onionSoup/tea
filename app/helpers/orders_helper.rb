module OrdersHelper
  def item_options
    options_of_existing_item = Item.all.map {|item| ["#{item.name}(#{item.price}円)", item.id] }
    options_with_blank = options_of_existing_item.unshift(['', ''])
  end

  def quantity_options
    (1..OrderDetail::MAX_NUMBER_OF_QUANTITY_OF_ONE_DETAIL).map {|i| ["#{i}個", i] }.unshift(['', ''])
  end

  def title_of_edit_order
    valid_details = current_user.order.order_details.reject {|detail| detail.invalid? }
    valid_details.any? ? '既存注文の修正' : '新規注文の作成'
  end

  def translate_state(state)
    case state
    when 'ordered'
      return '未発送'
    when 'arrived'
      return '引換可能'
    when 'exchanged'
      return '引換済み'
    else
      raise 'passing undefined state of orders to translate_state'
    end
  end

  def explain_state(state)
    case state
    when 'ordered'
      return '注文は発注されました。ネスレからの発送を待っています。<br>お茶が届けば、引換ができます。<br>なお、既に管理者がネスレに発注したため、注文の修正はできません。'
    when 'arrived'
      return 'お茶が支社に届いています。<br>管理者に代金を渡して引換をしてください。'
    when 'exchanged'
      return '引換済みです。<br>新たに注文したい場合、管理者に引換済み情報の削除を依頼してください。'
    else
      raise 'passing undefined state of orders to state_of_jp'
    end
  end

  def link_to_edit_or_show(edit_link_text, show_link_text)
    if current_user.order.state == 'registered'
      return content_tag :a, href: edit_order_path do "#{edit_link_text}" end
    else
      return content_tag :a, href: order_path do "#{show_link_text}" end
    end
  end
end

