require 'rails_helper'

feature 'ユーザー作成' do
  scenario '有効な名前を入力して送信ボタンを押すとユーザーができてユーザー名がでる' do
    visit new_user_path
    fill_in 'user_name' , :with => 'Bob'

    click_button '登録する'

    expect(page).to have_content 'こんにちはBobさん'
  end
  scenario '無効な名前を入力して送信ボタンを押すと失敗時のメッセージがでる' do
    visit new_user_path
    fill_in 'user_name' , :with => ''

    click_button '登録する'

    expect(page).to have_content '名前を入力してください。'
  end
end
