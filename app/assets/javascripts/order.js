$(function () {
  var $div = $('div.order_details_form');

  $('.name_price_options , .quantity_options').change(function () {
    var order = [],
        sum = 0,
        $selected = $div.find('option:selected'),
        detailSize = $selected.length / 2,
        i,
        detail_factory = function (index) {
          var detail = {};
          detail.price = $selected.slice(index * 2, index * 2 + 2)[0]//<option value="1">ジャスミン フラワー(756円)</option>
                                  .text.match(/(\d+)円/)[1];
          detail.quantity = $selected.slice(index * 2, index * 2 + 2)[1]//<option value="0">0個</option>
                                     .text.match(/\d+/)[0];
          return detail;
        };

    for (i = 0; i < detailSize; i++) {
      order.push(detail_factory(i));
    }

    sum = order.reduce(function (memo, detail) {
      return memo + detail.price * detail.quantity;
    }, 0);

    $('#order_create_price_sum').text('合計: ' + sum + '円');
  });
});
