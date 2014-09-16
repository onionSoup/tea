shared_examples '注文期限は切れていて、空注文を発注していない' do
  background do
    raise 'not_registered order must be .details.present' if Order.all.any?{|order| order.order_details.empty? && order.not_registered? }
    raise 'period must be out_of_date' unless Period.out_of_date?
  end
end

shared_examples '注文期限を未設定にはできない' do
  it '' do
    begin
      Period.set_undefined_times!
    rescue ActiveRecord::RecordInvalid => e
      expect(e.record).to be_invalid
    end
  end
end

shared_examples '注文期限を現在を含む期間にはできない' do
  it '' do
    begin
      Period.set_one_week_term_include_now!
    rescue ActiveRecord::RecordInvalid => e
      expect(e.record).to be_invalid
    end
  end
end

shared_examples '有効な日時を選択して注文期限を設定でき、無効な日時ではできない' do
  it '明日以降の有効な日付を選択して注文期限を変更できる' do
    choose_date(days_since: 1)
    click_button '注文期限の設定'

    flash = "注文期限を#{I18n.l(Period.singleton_instance.end_time.in_time_zone('Tokyo'))}に設定しました。"
    expect(page).to have_content flash
  end

  it '過去の日付を選択すると注文期限を変更できない' do
    choose_date(days_since: -1)
    click_button '注文期限の設定'

    expect(page).to have_content '注文期限が不正です。'
  end

  it '今日を選択すると、注文期限を変更できない' do
    choose_date(days_since: 0)
    click_button '注文期限の設定'

    expect(page).to have_content '注文期限が不正です。'
  end

  it '存在しない日付を選択すると注文期限を変更できない' do
    choose_date(year: Time.zone.now.year.succ, month: 2, day: 31)
    click_button '注文期限の設定'

    expect(page).to have_content '指定した日付は存在しません。'
  end
end

shared_examples 'カートの絵はpositionにいる' do |position: ''|
  it '' do
    within '#cart_target' do
      expect(page).to have_content position
    end
  end
end

shared_examples '注文の状況の見出しはstateになっている' do |state: ''|
  it '' do
    within '#order_state_bar_title' do
      expect(page).to have_content state
    end
  end
end

shared_examples '明細一覧にはお茶があって、削除できる' do |tea_name: 'herb_tea'|
  it '' do
    within '#order_details_index_table' do
      expect(page).to have_content tea_name
    end
    within '#order_details_index_table' do
      click_link '削除'
    end
    expect(page).to have_content "#{tea_name}の注文を削除しました。"
  end
end

shared_examples '明細一覧にはお茶があって、削除できない' do |tea_name: 'herb_tea'|
  it '' do
    within '#order_details_index_table' do
      expect(page).to have_content tea_name
    end
    within '#order_details_index_table' do
      expect(page).not_to have_link '削除'
    end
  end
end

shared_examples '明細一覧にはお茶が１つもない' do
  it '' do
    within '#order_details_index_table' do
      expect(page).to have_content 'お茶を注文していません'
    end
  end
end

shared_examples '注文の追加が可能と見出しからわかり、ボタンを押して追加できる' do |tea_name: :red_tea|
  it '' do
    within '#add_tea_title' do
      expect(page).to have_content '可能'
    end
    choose_item_and_quantity items(tea_name), 1
    click_button '追加する'

    expect(page).to have_content "#{tea_name.to_s}を追加しました。"
  end
end

shared_examples '注文の追加が不可と見出しからわかり、ボタンを押して追加できない' do
  it '' do
    within '#add_tea_title' do
      expect(page).to have_content '不可'
    end
    within 'form' do
      expect(page).to have_css '[type=submit][disabled=disabled]'
    end
  end
end


shared_examples '注文合計金額がsum円である' do |sum: nil|
  it '' do
    within '#orders_price_sum' do
      expect(page).to have_content "#{sum}円"
    end
  end
end

shared_examples '注文している人はcount人である' do |count: nil|
  it '' do
    within '#order_headcount' do
      expect(page).to have_content "#{count}人"
    end
  end
end

shared_examples '１人あたりの送料はprice円' do |price: nil|
  it '' do
    within '#current_postage_dialog' do
      expect(page).to have_content "#{price}円"
    end
  end
end

