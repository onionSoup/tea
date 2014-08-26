# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def make_items!
  items =
  [
    ['ジャスミン フラワー', 756],
    ['ルイボス オレンジ', 756],
    ['福建省烏龍茶', 756],
    ['アイス ミント', 756],
    ['サニー グレープフルーツ', 756],
    ['ノワール デラックス', 756],
    ['ノワール インペリアル', 756],
    ['グッド モーニング サンシャイン', 756],
    ['アールグレイ ライム', 756],
    ['セイロン ヌワラ', 756],
    ['レモン ローズヒップ ソルベ', 756],
    ['パイムータン フィネス'  , 756],
    ['トロピカル セレクション' , 756],
    ['バーベナ シトラス'  , 756],
    ['ロイヤル雲南', 756],
    ['スプリーム ダージリン', 756],
    ['インテンス・ミント', 756],
    ['玄米茶', 756],
    ['霧島煎茶', 756],
    ['アールグレイ', 756],
    ['イングリッシュ ブレックファスト', 756],
    ['ルイボス ブルボンバニラ', 756],
    ['レッド フルーツ ディライト', 756],
    ['ブルーベリー マフィン', 756],
    ['レッドロマンス', 756],
    ['ダージリンファーストフラッシュ', 1296],
    ['オーグリーン', 864]
  ]

  items.each do |item|
    Item.create!(name: item[0], price: item[1])
  end
end

def make_details!
  (0..3).map{|i| Detail.new(item_id: i+1, quantity: i+1) }
end

def make_users!
  user_names = %w(Alice Bob)
  user_names.each do |user_name|
    user = User.create!(name: user_name)
    user.update_attributes!(details: make_details!)
  end
end

def make_order!
  last_order = Order.create(
    begin_time: Time.zone.now.last_month.beginning_of_month,
    end_time:   Time.zone.now.last_month.end_of_month)
  now_order  = Order.create(
    begin_time: Time.zone.now.beginning_of_month, 
    end_time:   Time.zone.now.end_of_month)

  Detail.all.each do |detail|
    detail.update_attributes!(order: now_order)
  end
end

make_items!
make_users!
make_order!
