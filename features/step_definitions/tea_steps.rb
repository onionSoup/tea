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

Given /^"(.*?)"円のお茶"(.*?)"を数量"(.*?)"個注文している$/ do |price, item_name, quantity|
  price_in_db = Item.find_by(name: item_name).price
  raise "price of #{item_name} must be #{price_in_db}. not given price #{price}" unless  price_in_db == price.to_i

  choose_item_and_quantity(item_name, quantity)
  click_button '追加する'
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
  row_index = OrderDetail.find_by(item: Item.find_by(name: item_name)).id

  within('#order_details_index_table') do
    within(".order_detail_#{row_index}") do
      click_link '削除'
    end
  end
end

When /^"(.*?)"のリンクをクリックする$/ do |link_text|
  click_link link_text
end

# FIXME
#本当は「明細表のｘ行目のｙはｚであること」みたいにしたい。
#でもそれだとorder_detailを消した時、n行目の行がid n であるという対応が崩れて間違いになる。
Then /^"(.*?)"番目に作った明細は、明細表で"(.*?)"が"(.*?)"であること$/ do |id, col_name, expected|
  within('#order_details_index_table') do
    within(".order_detail_#{id}") do
        td_text = find(to_class_name(col_name)).text
        expect(td_text).to eq expected
    end
  end
end

Then /^明細表が以下になること$/ do |table|
  table.hashes.each do |row|
    id = OrderDetail.find_by(item:  Item.find_by(name: row['品名'])).id
    row.keys.each do |col_name|
      step %Q{"#{id}"番目に作った明細は、明細表で"#{col_name}"が"#{row[col_name]}"であること}
    end
  end
end

Then /商品ごとに集計した表が以下と等しいこと$/ do |table|
  table.hashes.each do |row|
    row.keys.each do |col_name|
      within('.all_user_sum_table') do
        within(".item_#{Item.find_by(name: row['商品名']).id}") do
          td_text = find(to_class_name_admin_order_table(col_name)).text
          expect(td_text).to eq row[col_name]
        end
      end
    end
  end
end

Then /^"(.*?)"の商品内訳の表が以下になること$/ do |user_name, table|
  tr_class_of_user = ".user_#{User.find_by(name: user_name).id}"
  within(tr_class_of_user) do
    all('.inner_table').zip(table.hashes.to_a).each do |detail, row|
      expect(detail.find('.name').text)    .to eq row['品名']
      expect(detail.find('.quantity').text).to eq row['数量']
    end
  end
end


Then /^"(.*?)"と表示されていること$/ do |content|
  expect(page).to have_content content
end

module StepDefinitionsUtil
  #あとでi18nにのせる
  def to_class_name(col_name)
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

  def to_class_name_admin_order_table(col_name)
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
end
include StepDefinitionsUtil
