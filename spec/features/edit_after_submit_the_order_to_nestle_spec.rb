feature 'ネスレ公式に発注した後の注文修正'do
  fixtures :items

  include_context 'herb_teaを注文しているAliceとしてログイン'

  scenario 'ネスレ入力用ページでボタンを押した後、注文の修正はできない' do
    visit '/orders/registered'

    click_button '注文の完了をシステムに登録'

    click_link '注文履歴'

    expect(page).to have_content '注文の作成・変更はできません。'
  end

  context 'Bobとしてログインし直す' do
    background do
      create_user_and_login_as 'Bob'
    end

    scenario 'Aliceの注文をネスレに発注した後でも、Alice以外の人の注文修正はできる。' do
      #Aliceの注文をネスレ公式に発注したことを、このアプリteaに登録する。
      visit '/orders/registered'
      click_button '注文の完了をシステムに登録'

      #Bobは注文できる。
      click_link '注文画面'

      choose_item_and_quantity 'herb_tea', 2
      click_button '追加する'
      click_link '管理者用'

      expect(page).to exist_in_table 'herb_tea'

      #Aliceの注文は発注されたので修正できない
      click_link 'ログアウト'
      login_as 'Alice'
      click_link '注文履歴'

      expect(page).to have_content '注文の作成・変更はできません。'
    end
  end

  scenario '注文情報を削除した後、注文期間を設定して、再度注文を作れる。' do
    #管理者用ページで注文の状態を更新していき、注文情報を削除する。
    form_visiting_registered_to_delete_exchanged_of alice

    #注文期間を再度設定する。TODO UIからやれるようにする。
    make_deadline_from_now_to_next_week
    visit page.current_path

    #注文情報削除後は、注文画面にいけることを確認する
    click_link '注文画面'
    expect(page).not_to have_content '注文の作成・変更はできません。'

    #注文情報削除後は、注文できることを確認する。
    choose_item_and_quantity 'herb_tea', 2
    click_button '追加する'

    expect(page).to exist_in_table 'herb_tea'
  end
end
