# language: ja
フィーチャ:  管理者が、注文の管理（発注、受領、引換の登録）をできるようにしたい

  シナリオ: 管理者として、発注する商品と、請求先ユーザーがわかる
    前提    ユーザー"Alice"が登録してログインしている
    前提    "100"円のお茶"herb_tea"を数量"1"個注文している
    前提    "100"円のお茶"red_tea"を数量"2"個注文している
    もし    ユーザー"Alice"がログアウトする

    前提    ユーザー"Bob"が登録してログインしている
    前提    "100"円のお茶"herb_tea"を数量"3"個注文している
    前提    "100"円のお茶"red_tea"を数量"4"個注文している
    もし    ユーザー"Bob"がログアウトする

    前提    ユーザー"Charlie"が登録してログインしている
    もし    "管理者用"のリンクをクリックする
    ならば  商品ごとに集計した表が以下と等しいこと
      | 商品名   | 単価 | 合計数量 |
      | herb_tea | 100 | 4        |
      | red_tea  | 100 | 6        |
