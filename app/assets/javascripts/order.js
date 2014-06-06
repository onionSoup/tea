$(function () {
  $('.name_price_options , .quantity_options').change(function () {
    var $div = $('div.order_details_form'),
        sum = $.makeArray($div).reduce(function (memo,div){
          //このチェーンをもっと綺麗に書き直したい
          price = $(div).children().filter(".name_price_options")
                        .children().filter("option:selected")
                        .text().match(/(\d+)円/)[1];

          quantity = $(div).children().filter(".quantity_options")
                           .children().filter("option:selected")
                           .text().match(/\d+/)[0];

          return memo + price * quantity;
        }, 0);

    $('#order_create_price_sum').text('合計: ' + sum + '円');
  });
});
