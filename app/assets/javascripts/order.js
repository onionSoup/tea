function calc_sum($sumLabel, $details) {
    var sum = $details.reduce(function(acc, detail) {
      var $detail   = $(detail),
          itemLabel = $detail.find('select.name_price_options option:selected').text();
      if (!itemLabel) return acc;

      var price     = itemLabel.match(/(\d+)円/)[1],
          quantity  = $detail.find('select.quantity_options').val();
      if (!quantity) return acc;

      return acc + price * quantity;
    }, 0);

    $sumLabel.text('合計: ' + sum + '円');
}

$(function() {
   var $sumLabel = $('#order_create_price_sum'),
       $details = $('div.order_details_form').toArray();

  calc_sum($sumLabel, $details);
  $('.name_price_options, .quantity_options').change(function(){
    calc_sum($sumLabel, $details)
  });
});
