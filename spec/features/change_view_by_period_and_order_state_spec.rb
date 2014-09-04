feature '「注文作成・変更」または「注文履歴」リンクから行けるページ' do
  feature '注文状態と注文期間によって、表示を適切に変える' do
    fixtures :items

    let(:header) {page.find('header')}
    let(:nav)    {page.find('nav')}

    let!(:alice) { create(:user, name: 'Alice') }

    before do
      Timecop.freeze(Time.zone.now)

      login_as 'Alice'
    end

    after do
      Timecop.return
    end

    context '注文が未発注の時' do
      context 'お茶を追加しているとき' do
        background do
          alice.order.update_attributes!(order_details: [build(:order_detail, item: items(:herb_tea), quantity: 1)])
        end
        context '現在、注文期間であるとき' do
          background do
            raise unless Period.include_now?
          end
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
        context '現在、注文期間中でないとき' do
          background do
            Timecop.freeze(Time.zone.now.days_since(8))
            raise unless Period.out_of_date?
          end
          scenario '注文画面に行こうとすると、注文履歴画面にリダイレクトされて通知がでる' do
            visit '/order_details'
            expect(page.current_path).to eq '/order'
            expect(page).to have_content '注文期限を過ぎているため、注文の作成・変更はできません。'
          end
          scenario '期限未設定の通知画面に行こうとすると、注文履歴画面にリダイレクトされて通知が出る' do
            visit '/period_notice'
            expect(page.current_path).to eq '/order'
            expect(page).to have_content '注文期限を過ぎているため、注文の作成・変更はできません。'
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
              expect(page).to     have_content '注文の状況'
            end
          end
        end
      end

      context 'お茶を追加していないとき' do
        context '現在、注文期間であるとき' do #お茶を追加している時と同じ
          background do
            raise unless Period.include_now?
          end
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
        context '現在、注文期間中でないとき' do
          background do
            Timecop.freeze(Time.zone.now.days_since(8))
            raise unless Period.out_of_date?
          end
          scenario '注文画面に行こうとすると、注文履歴画面にリダイレクトされて通知がでる' do
            visit '/order_details'
            expect(page.current_path).to eq '/order'
            expect(page).to have_content '注文期限を過ぎているため、注文の作成・変更はできません。'
          end
          scenario '期限未設定の通知画面に行こうとすると、注文履歴画面にリダイレクトされて通知が出る' do
            visit '/period_notice'
            expect(page.current_path).to eq '/order'
            expect(page).to have_content '注文期限を過ぎているため、注文の作成・変更はできません。'
          end
          context '注文履歴画面にいったとき' do
            background do
              visit '/order'
            end
            scenario 'リンクは「注文画面」と「注文の作成・変更」になっている' do
              expect(header).to have_link '注文画面'
              expect(nav).to    have_link '注文作成・変更'
            end
            scenario '注文が追加できない' do
              expect(page).not_to have_button '追加する'
              expect(page).to     have_content '注文の状況: 未注文'
              expect(page).to     have_content '注文期限がすぎたため、管理者が再度注文を受けつけるようになるまで注文の作成・変更はできません。'
            end
          end
        end

        context '注文期間が設定されていないとき' do
        end
      end
    end

    context '注文が発送済みのとき' do
    end

    context '注文が引換可能なとき' do
    end
    context '注文が引換済みのとき' do
    end
  end
end
