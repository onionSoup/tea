# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#users
User.create(name: 'Alice')
 User.create(name: 'Bob')

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

items.each do |item|
  Item.create(name: item[0], price: item[1])
end

#order_details
#first_user
alice = User.find_by_name('Alice')
4.times do |i| alice.order.order_details.build(item_id: i, quantity: i+1) end
alice.save

#second_user
bob = User.find_by_name('Bob')
4.times do |i| bob.order.order_details.build(item_id: i, quantity: i+1) end
bob.save
