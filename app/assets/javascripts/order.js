$(function() {
   //増えると後から
   var $sumLabel = $('#order_create_price_sum'),
   //ｓだけでaryの意味は組まれる
       $details = $('div.order_details_form').toArray();

  $('.name_price_options, .quantity_options').change(function() {
    var sum = $details.reduce(function(acc, detail) {
      var $detail   = $(detail),
          //説明用の変数
          itemLabel = $detail.find('select.name_price_options option:selected').text(),
          price     = itemLabel.match(/(\d+)円/)[1],
          //value属性
          quantity  = $detail.find('select.quantity_options').val();

      return acc + price * quantity;
    }, 0);

    //sumは数字  sumLabelは表現
    //データ（プログラム内部で使う）と表現（ユーザーが見る）の分離
    $sumLabel.text('合計: ' + sum + '円');
  });
});
