feature '商品を指定した順番に並べる' do

  let!(:herb_tea) {Item.create!(
    name:                      'herb_tea',
    price:                     100,
    nestle_index_from_the_top: 0
  )}

  let!(:red_tea) {Item.create!(
    name:                      'red_tea',
    price:                     100,
    nestle_index_from_the_top: 1
  )}

  let!(:ice_mint) {Item.create!(
    name:                      'ice_mint',
    price:                     100,
    nestle_index_from_the_top: 2
  )}

  background do
    create_user_and_login_as 'Alice'
    click_link '管理者用'
    click_link '商品の編集・削除'
  end

  context '商品一覧を見るとき' do
    it_behaves_like 'item_namesの順に並んでいる', item_names: ['herb_tea', 'red_tea', 'ice_mint']
  end

  context '商品を作るとき' do
    scenario '順番を変更しない という選択肢がない' do
      click_link '新商品登録ページ'
      within 'select#item_nestle_index_from_the_top' do
        expect(page).to have_content     '一番最後'
        expect(page).not_to have_content '順番を変更しない'
      end
    end

    context 'herb_teaの前に挿入するとき' do
      background do
        click_link '新商品登録ページ'
        fill_in '商品名',      with: 'new_tea'
        fill_in '価格',        with: '1255'
        select 'herb_teaの前', from: '並び順'
        click_button '保存する'
      end

      it_behaves_like 'item_namesの順に並んでいる', item_names: ['new_tea', 'herb_tea', 'red_tea', 'ice_mint']
    end

    context 'red_teaの前に挿入するとき' do
      background do
        click_link '新商品登録ページ'
        fill_in '商品名',      with: 'new_tea'
        fill_in '価格',        with: '1255'
        select 'red_teaの前', from: '並び順'
        click_button '保存する'
      end

      it_behaves_like 'item_namesの順に並んでいる', item_names: ['herb_tea', 'new_tea', 'red_tea', 'ice_mint']
    end

    context '一番最後に挿入するとき' do
      background do
        click_link '新商品登録ページ'
        fill_in '商品名',      with: 'new_tea'
        fill_in '価格',        with: '1255'
        select '一番最後', from: '並び順'
        click_button '保存する'
      end

      it_behaves_like 'item_namesの順に並んでいる', item_names: ['herb_tea', 'red_tea', 'ice_mint', 'new_tea']
    end
  end

  context '商品を編集するとき' do
    context 'herb_teaを編集するとき' do
      background do
        within ".#{ActionView::RecordIdentifier.dom_id(herb_tea, :change)}" do
          click_link '編集'
        end
      end
      context '順番を変更しないを選ぶとき' do
        background do
          fill_in '商品名',      with: 'herb_tea'
          fill_in '価格',        with: '100'
          select  '順番を変更しない', from: '並び順'
          click_button '保存する'
        end
        it_behaves_like 'item_namesの順に並んでいる', item_names: ['herb_tea', 'red_tea', 'ice_mint']
      end

      context '一番最後を選ぶとき' do
        background do
          fill_in '商品名',      with: 'herb_tea'
          fill_in '価格',        with: '100'
          select  '一番最後',    from: '並び順'
          click_button '保存する'
        end
        it_behaves_like 'item_namesの順に並んでいる', item_names: ['red_tea', 'ice_mint', 'herb_tea']
      end
    end
    context 'ice_mintを編集するとき' do
      background do
        within ".#{ActionView::RecordIdentifier.dom_id(ice_mint, :change)}" do
          click_link '編集'
        end
      end
      scenario '一番最後という選択肢がない' do
        within 'select#item_nestle_index_from_the_top' do
          expect(page).not_to have_content     '一番最後'
          expect(page).to     have_content '順番を変更しない'
        end
      end
    end
  end

  context '商品を消すとき' do
    context 'herb_teaを消すとき' do
      background do
        within ".#{ActionView::RecordIdentifier.dom_id(Item.find_by(name: 'herb_tea'), :change)}" do
          click_link '削除'
        end
      end

      it_behaves_like 'item_namesの順に並んでいる', item_names: ['red_tea', 'ice_mint']
    end
    context 'red_teaを消すとき' do
      background do
        within ".#{ActionView::RecordIdentifier.dom_id(Item.find_by(name: 'red_tea'), :change)}" do
          click_link '削除'
        end
      end

      it_behaves_like 'item_namesの順に並んでいる', item_names: ['herb_tea', 'ice_mint']
    end
    context 'ice_mintを消すとき' do
      background do
        within ".#{ActionView::RecordIdentifier.dom_id(Item.find_by(name: 'ice_mint'), :change)}" do
          click_link '削除'
        end
      end

      it_behaves_like 'item_namesの順に並んでいる', item_names: ['herb_tea', 'red_tea']
    end

    context '新商品を作った後で新商品を消すとき' do
      background do
        click_link '新商品登録ページ'
        fill_in '商品名',      with: 'new_tea'
        fill_in '価格',        with: '1255'
        select 'red_teaの前', from: '並び順'
        click_button '保存する'

        within ".#{ActionView::RecordIdentifier.dom_id(Item.find_by(name: 'new_tea'), :change)}" do
          click_link '削除'
        end
      end

      it_behaves_like 'item_namesの順に並んでいる', item_names: ['herb_tea', 'red_tea', 'ice_mint']
    end

    context '新商品を作った後で既存商品を消すとき' do
      background do
        click_link '新商品登録ページ'
        fill_in '商品名',      with: 'new_tea'
        fill_in '価格',        with: '1255'
        select 'red_teaの前', from: '並び順'
        click_button '保存する'

        within ".#{ActionView::RecordIdentifier.dom_id(Item.find_by(name: 'ice_mint'), :change)}" do
          click_link '削除'
        end
      end

      it_behaves_like 'item_namesの順に並んでいる', item_names: ['herb_tea', 'new_tea', 'red_tea',]
    end

    context '既存商品を消した後で新商品を作るとき' do
      background do
        within ".#{ActionView::RecordIdentifier.dom_id(Item.find_by(name: 'ice_mint'), :change)}" do
          click_link '削除'
        end

        click_link '新商品登録ページ'
        fill_in '商品名',      with: 'new_tea'
        fill_in '価格',        with: '1255'
        select 'herb_teaの前', from: '並び順'
        click_button '保存する'
      end

      it_behaves_like 'item_namesの順に並んでいる', item_names: ['new_tea', 'herb_tea', 'red_tea',]
    end
  end
end
