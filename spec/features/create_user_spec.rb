feature 'ユーザー登録' do
  background do
    visit 'users/new'
  end

  scenario '有効な名前を入力して送信ボタンを押すとユーザーができてユーザー名がでる' do
    fill_in 'ユーザー名' , :with => 'Bob'

    click_button '登録する'

    expect(page).to have_content 'こんにちはBobさん'
  end

  scenario '無効な名前を入力して送信ボタンを押すと失敗時のメッセージがでる' do
    fill_in 'ユーザー名' , :with => ''

    click_button '登録する'

    expect(page).to have_content '名前を入力してください。'
  end
end
