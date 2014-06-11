require 'rails_helper'

feature '注文作成' do
  scenario '何も選択せずに注文ボタンを押すと、同じ画面に' do
    #以下４行のサインインはまとめる方がいい
    #データ作成はfactory_girlで
    User.create name: 'Bob'
    visit new_session_path
    fill_in 'sessions_name' , :with => 'Bob'
    click_button 'ログイン'

    click_button '注文を確定する'
    expect(page.current_path).to eq(orders_path)
  end

  scenario '品名と量を指定して注文すると注文ができて、注文確認画面にいく' do
  end
end
