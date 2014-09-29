require "#{File.expand_path(__dir__)}/../../spec/support/example_helper"
include ExampleHelper

Given /^ユーザー"(.*?)"がユーザー登録している$/ do |user_name|
  create :user, name: user_name
end

Given /^ユーザー"(.*?)"がログインしている$/ do |user_name|
  login_as user_name
end

Given /^ユーザー"(.*?)"が登録してログインしている$/ do |user_name|
  create_user_and_login_as user_name
end

Given /^"(.*?)"円のお茶"(.*?)"を"(.*?)"個注文している$/ do |price, item_name, quantity|
  raise_error_if_wrong_price_passed(item_name, price)

  choose_item_and_quantity(item_name, quantity)
  click_button '追加する'
end

Given /^ユーザー"(.*?)"が"(.*?)"円のお茶"(.*?)"を"(.*?)"個注文している$/ do |user_name, price, item_name, quantity|
  step %Q{ユーザー"#{user_name}"がログインしている}
  step %Q{"#{price}"円のお茶"#{item_name}"を"#{quantity}"個注文している}
  step %Q{ユーザー"#{user_name}"がログアウトする}
end

Given /^引換用ページにいる$/ do
  visit '/orders/arrived'
end

When /^ユーザー"(.*?)"がログアウトする$/ do |user_name|
  login_user_name = get_user_name_from_header!
  if login_user_name == User.find_by(name: user_name).name
    click_link 'ログアウト'
  else
    raise "before logout, #{user_name} must be logged in"
  end
end

When /^注文画面を表示する$/ do
  visit '/order_details'
end

When /^品名"(.*?)"を選ぶ$/ do |item_name|
  choose_item item_name
end

When /^数量"(.*?)"を選ぶ$/ do |quantity|
  choose_quantity quantity
end

When /^"(.*?)"ボタンを押す$/ do |button_text|
  click_button button_text
end

When /^品名"(.*?)"の削除リンクをクリックする$/ do |item_name|
  row_index = detail_id_from_item_name!(item_name)
  within('#order_details_index_table') do
    within(".order_detail_#{row_index}") do
      click_link '削除'
    end
  end
end

When /^"(.*?)"のリンクをクリックする$/ do |link_text|
  click_link link_text
end

When /^"(.*?)"のボタンを押す$/ do |button_text|
  click_button button_text
end

When /^注文をネスレに発注する$/ do
  visit '/orders/registered'
  click_button '発注の完了をシステムに登録'
end

When /^お茶が発送されたことを登録する$/ do
  visit '/orders/ordered'
  click_button 'お茶の受領をシステムに登録'
end

When /^"(.*?)"の引換完了チェックにチェックを入れる$/ do |user_name|
  check "user_#{User.find_by(name: "Alice").id}"
end

When /^注文期限がきれるまで待つ$/ do
  wait_untill_period_become_out_of_date
end

When /^ページをリロードする$/ do
  visit page.current_path
end

# FIXME
#本当は「明細表のｘ行目のｙはｚであること」みたいにしたい。
#でもそれだとorder_detailを消した時、n行目の行がid n であるという対応が崩れて間違いになる。
Then /^"(.*?)"番目に作った明細は、明細表で"(.*?)"が"(.*?)"であること$/ do |id, col_name, expected|
  within('#order_details_index_table') do
    within(".order_detail_#{id}") do
      td_text = find(to_class_in_details_table(col_name)).text
      expect(td_text).to eq expected
    end
  end
end

Then /^明細表が以下になること$/ do |table|
  table.hashes.each do |row|
    id = detail_id_from_item_name!(row['品名'])
    row.keys.each do |col_name|
      step %Q{"#{id}"番目に作った明細は、明細表で"#{col_name}"が"#{row[col_name]}"であること}
    end
  end
end

Then /商品ごとに集計した表が以下と等しいこと$/ do |table|
  table.hashes.each do |row|
    row.keys.each do |col_name|
      within(".item_#{Item.find_by(name: row['商品名']).id}") do
        td_text = find(to_class_in_aggregate_table(col_name)).text
        expect(td_text).to eq row[col_name]
      end
    end
  end
end

Then /^"(.*?)"の商品内訳の表が以下になること$/ do |user_name, table|
  tr_class_of_user = ".user_#{User.find_by(name: user_name).id}"
  within(tr_class_of_user) do
    all('.inner_table').zip(table.hashes).each do |detail, row|
      expect(detail.find('.name').text)    .to eq row['品名']
      expect(detail.find('.quantity').text).to eq row['数量']
    end
  end
end

Then /^"(.*?)"の商品内訳は表にないこと$/ do |user_name|
  tr_class_of_user = ".user_#{User.find_by(name: user_name).id}"

  expect(page).not_to have_css(tr_class_of_user)
end

Then /^"(.*?)"と表示されていること$/ do |content|
  expect(page).to have_content content
end

Then /^ネスレ発送待ち商品の確認用のページに飛ぶこと$/ do
  expect(page.current_path).to eq '/orders/ordered'
end

Then /^引換用ページに飛ぶこと$/ do
  expect(page.current_path).to eq '/orders/arrived'
end

Then /^引換済み商品ページに飛ぶこと$/ do
  expect(page.current_path)
end

module StepDefinitionsUtil
  #日→英だし、step以外では使わないのでI18でやらないことにする
  def to_class_in_details_table(col_name)
    case col_name
    when '品名'
      '.name'
    when '数量'
      '.quantity'
    when '単価'
      '.price'
    when '小計'
      '.sum'
    when ''
      '.destroy'
    else
      raise "pass invalid arg '#{col_name}' to #{__method__}"
    end
  end

  def to_class_in_aggregate_table(col_name)
    case col_name
    when '商品名'
      '.name'
    when '単価'
      '.price'
    when '合計数量'
      '.sum'
    else
      raise "pass invalid arg '#{col_name}' to #{__method__}"
    end
  end

  def get_user_name_from_header!
    within('header') do
      match_data = find('#greeting').text.match /^こんにちは(.*?)さん$/
      match_data[1]
    end
  rescue
    raise 'ヘッダーから名前を取得できません。'
  end

  def detail_id_from_item_name!(item_name)
    item = Item.find_by!(name: item_name)
    OrderDetail.find_by!(item: item).id
  end

  def raise_error_if_wrong_price_passed(item_name, price)
    price_in_db = Item.find_by(name: item_name).price
    unless  price_in_db == price.to_i
      raise "must pass price same as #{price_in_db}, which price_in_db"
    end
  end
end
include StepDefinitionsUtil
