shared_examples '注文画面にのみ行けて、リンクは「注文画面」になっている' do
  scenario '注文履歴画面に行こうとすると、注文画面にリダイレクト' do
    visit '/order'
    expect(page.current_path).to eq '/order_details'
  end
  scenario '期限未設定の通知画面に行こうとすると、注文画面にリダイレクト' do
    visit '/period_notice'
    expect(page.current_path).to eq '/order_details'
  end
  context '注文画面にいったとき' do
    background do
      visit '/order_details'
    end
    scenario 'リンクは「注文画面」と「注文作成・変更」になっている' do
      expect(header).to have_link '注文画面'
      expect(nav).to    have_link '注文作成・変更'
    end
    scenario '注文が追加できる' do
      choose_item_and_quantity 'red_tea', 1
      click_button '追加する'

      expect(page).to have_content 'red_teaを追加しました。'
    end
  end
end


shared_examples '注文期限は切れていて、空注文を発注していない' do
  background do
    raise 'not_registered order must be .details.present' if Order.all.any?{|order| order.order_details.empty? && order.not_registered? }
    raise 'period must be out_of_date' unless Period.out_of_date?
  end
end


shared_examples '注文履歴画面にのみ行けて、リンクは「履歴」になっている' do
  scenario '注文画面に行こうとすると、注文履歴画面にリダイレクトされて通知がでる' do
    visit '/order_details'
    expect(page.current_path).to eq '/order'
    expect(page).to have_content '既に管理者がネスレに発注したため、注文の作成・変更はできません。'
  end
  scenario '期限未設定の通知画面に行こうとすると、注文履歴画面にリダイレクトされて通知が出る' do
    visit '/period_notice'
    expect(page.current_path).to eq '/order'
    expect(page).to have_content '既に管理者がネスレに発注したため、注文の作成・変更はできません。'
  end
  context '注文履歴画面にいったとき' do
    background do
      visit '/order'
    end
    scenario 'リンクは「注文履歴」と「履歴・発送状態」になっている' do
      expect(header).to have_link '注文履歴'
      expect(nav).to    have_link '履歴・発送状態'
    end
    scenario '注文が追加できない' do
      expect(page).not_to have_button '追加する'
    end
  end
end
