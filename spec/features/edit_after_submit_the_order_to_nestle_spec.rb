feature 'ネスレ公式に発注した後の注文修正'do
  fixtures :items

  include_context 'herb_teaを注文しているAliceとしてログイン'
  include_context '注文期間がすぎるまで待つ'

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

    scenario '注文期間がすぎた後、Alice以外の人の注文修正もできない。' do
      #Aliceの注文をネスレ公式に発注したことを、このアプリteaに登録する。
      visit '/orders/registered'
      click_button '注文の完了をシステムに登録'

      #Bobも注文できない。注文期間がすぎたため。
      click_link '注文画面'

      expect(page).to have_content '注文期限を過ぎているため、注文の作成・変更はできません。'

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

    #明示的に注文期間を削除しない限り、期限切れの注文期間になっている。
    expect(Period).to be_out_of_date

    #注文期間を再度設定する。
    make_deadline_from_now_to_after_seven_days
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
