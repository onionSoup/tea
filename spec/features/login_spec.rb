#これとは別に、ExampleHelper.create_user_and_login_as()を用意。
feature 'ログインする' do
  background do
    visit '/sessions/new'
    create :user, name: 'Bob'
  end

  scenario '有効な名前を入力して送信ボタンを押すとログインしてユーザー名がでる' do
    fill_in 'ユーザー名' , with: 'Bob'
    click_button 'ログイン'

    expect(page).to have_content 'こんにちはBobさん'
  end

  scenario '無効な名前を入力して送信ボタンを押すとログイン失敗メッセージがでる' do
    fill_in 'ユーザー名' , with: 'Alice'
    click_button 'ログイン'

    expect(page).to have_content 'そのユーザは存在しません。新規ユーザー登録してください'
  end
end
