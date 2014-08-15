module OrdersHelper
  def item_options
    options_of_items = Item.all.map {|item| ["#{item.name}(#{item.price}円)", item.id] }
    options_with_blank = options_of_items.unshift(['', ''])
  end

  def quantity_options
    (1..OrderDetail::MAX_NUMBER_OF_QUANTITY_OF_ONE_DETAIL).map {|i| ["#{i}個", i] }
                                                          .unshift(['', ''])
  end

  #translate_stateとexpalin_stater両方でcase使っていたら、code climateさんに怒られたので。
  #と思ったら、caseを追い出してもまだ駄目とのこと。
  def state_to_message(arg)
    case arg[:state]
    when 'registered'
      arg[:message][:registered]
    when 'ordered'
      arg[:message][:ordered]
    when 'arrived'
      arg[:message][:arrived]
    when 'exchanged'
      arg[:message][:exchanged]
    else
      raise "#{arg[:error]}"
    end
  end

  def translate_state(state)
    state_to_message(
      {
        state: state,
        message:
        {
          registered: '未発注',
          ordered: '未発送',
          arrived: '引換可能',
          exchanged: '引換済み'
        },
        error: "passing undefined state of orders to #{__method__}"
      }
    )
  end

  def explain_state(state)
    state_to_message(
      {
       state: state,
       message:
        {
          #registered: これはorders/showでは使わないので不要。
          ordered: '注文は発注されました。ネスレからの発送を待っています。<br>お茶が届けば、引換ができます。<br>なお、既に管理者がネスレに発注したため、注文の修正はできません。',
          arrived: 'お茶が支社に届いています。<br>管理者に代金を渡して引換をしてください。',
          exchanged: '引換済みです。<br>新たに注文したい場合、管理者に引換済み情報の削除を依頼してください。'
        },
      error: "passing undefined state of orders to #{__method__}"
      }
    )
  end
  #link_to_details_index_or_order_showだと長い。
  def link_to_index_or_show(index_link_text, show_link_text)
    if current_user.order.registered?
      content_tag(:a, href: order_details_path) { "#{index_link_text}" }
    else
      content_tag(:a, href: order_path) { "#{show_link_text}" }
    end
  end
end
