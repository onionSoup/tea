# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#users
if(!User.first)
  User.create(name: 'user1')
end

#time  #admin #exchange
if(!TimeLimit.first)
  d1 = Date.new(2014,5,10)
  d2 = Date.new(2014,6,10)
  t = TimeLimit.create(start: d1, end: d2)
  t.create_admin_order
  t.create_exchange(exchange_flag: false)
end

#items
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
  ['レッドロマンス', 756]
]
if(!Item.first)
  items.each { |item|
    Item.create(name: item[0], price: item[1])
  }
end