feature '注文画面' do
  feature '注文の状況の文言' do
    fixtures :items

    include_context 'herb_teaを注文しているAliceとしてログイン'

    context 'ネスレ公式に発注済みの時' do
      include_context '注文期間がすぎるまで待つ'

      context 'お茶が未だ届いていない時' do
        background do
          alice.order.update_attributes state: 'ordered'
        end

        scenario '注文画面に行くと、お茶が発送待ちであるとわかる。' do
          visit order_path
          expect(page).to have_content '注文の状況: 発送待ち'
        end
      end

      context 'お茶が支社に届いている時' do
        background do
          alice.order.update_attributes state: 'arrived'
        end

        scenario '注文履歴ページに行くと、お茶が引換可能であるとわかる。' do
          visit order_path

          expect(page).to have_content '注文の状況: 引換可能'
        end
      end

      context 'お茶が引換済みの時' do
        background do
          alice.order.update_attributes state: 'exchanged'
        end

        scenario '注文履歴ページに行くと、お茶が引換済みであるとわかる。' do
          visit order_path

          expect(page).to have_content '注文の状況: 引換済み'
        end
      end
    end
  end
end
