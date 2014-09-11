#TODO これは、すべて使えないかも。。ただ、時間帯移動を書いたものなので、別の見た目を検証するために残すかも
=begin
feature '注文画面ページ' do
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
          it_should_behave_like '注文画面にのみ行けて、リンクは「注文画面」になっている'
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
        context '現在、注文期間であるとき' do
          background do
            raise unless Period.include_now?
          end
          it_should_behave_like '注文画面にのみ行けて、リンクは「注文画面」になっている'
        end

        context '現在、注文期間中でないとき' do
          include_context '注文期間がすぎるまで待つ'
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
          background do
            Period.set_undefined_times!
          end
          scenario '注文画面に行こうとすると、期限未設定の通知画面にリダイレクト' do
            visit '/order_details'
            expect(page.current_path).to eq '/period_notice'
          end
          scenario '注文履歴画面に行こうとすると、期限未設定の通知画面にリダイレクト' do
            visit '/order'
            expect(page.current_path).to eq '/period_notice'
          end
          context '期限未設定の通知画面にいったとき' do
            scenario 'リンクは「注文画面」と「注文の作成・変更」になっている' do
              expect(header).to have_link '注文画面'
              expect(nav).to    have_link '注文作成・変更'
            end
          end
        end
      end
    end

    context '注文が発注済みのとき' do
      include_context '注文期間がすぎるまで待つ'

      background do
        alice.order.update_attributes!(order_details: [build(:order_detail, item: items(:herb_tea), quantity: 1)])
      end

      context '注文が発送前のとき' do
        background do
          alice.order.update_attributes!(state: Order.states['ordered'])
        end
        it_should_behave_like '注文期限は切れていて、空注文を発注していない'
        it_should_behave_like '注文履歴画面にのみ行けて、リンクは「履歴」になっている'
      end
      context '注文が引換可能なとき' do
        background do
          alice.order.update_attributes!(state: Order.states['arrived'])
        end
        it_should_behave_like '注文期限は切れていて、空注文を発注していない'
        it_should_behave_like '注文履歴画面にのみ行けて、リンクは「履歴」になっている'
      end
      context '注文が引換済みのとき' do
        background do
          alice.order.update_attributes!(state: Order.states['exchanged'])
        end
        it_should_behave_like '注文期限は切れていて、空注文を発注していない'
        it_should_behave_like '注文履歴画面にのみ行けて、リンクは「履歴」になっている'
      end
    end
  end
end
=end
