# language: ja
フィーチャ: ユーザがお茶を注文できるようにしたい

  シナリオ: ログインしているユーザが、お茶を注文できる
    前提    ユーザー"Alice"が登録してログインしている
    もし    品名"herb_tea"を選ぶ
    もし    数量"1"を選ぶ
    もし    "追加する"ボタンを押す
    もし    品名"red_tea"を選ぶ
    もし    数量"2"を選ぶ
    もし    "追加する"ボタンを押す
    ならば  明細表が以下になること
      | 品名    | 数量 |
      | herb_tea| 1個 |
      | red_tea | 2個 |

  シナリオ: 追加したお茶を削除できる
    前提    ユーザー"Alice"が登録してログインしている
    前提    お茶"herb_tea"を数量"1"個注文している
    前提    お茶"red_tea"を数量"3"個注文している
    もし    品名"herb_tea"の削除リンクをクリックする
    ならば  "herb_teaの注文を削除しました。"と表示されていること
    かつ    明細表が以下になること
      | 品名     | 数量 |
      | red_tea | 3個 |
