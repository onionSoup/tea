require "#{File.expand_path(__dir__)}/../../spec/support/example_helper"
include ExampleHelper

Given /^ユーザ"(.*?)"がログインしている$/ do |user_name|
  create_user_and_login_as user_name
end

When /^注文画面を表示する/ do
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

Then /^"(.*?)"と表示されていること$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end
