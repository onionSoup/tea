$(function() {
  $('.name_price_options , .quantity_options').change(function() {
    //選択したoptionを、priceとquantityでわけて取り出す
    var selectedOptions = function() {
      var $div = $('div.order_details_form'),
          $selectedBothOptions = $div.find('option:selected');

      return {
        price:     $selectedBothOptions.filter('.name_price_options > option'),
        quantity:  $selectedBothOptions.filter('.quantity_options > option')
      };
    }(),

        //正規表現で処理する前の、生(crude)のpriceとquantityを返す
        crudeOptionContents = function() {
          var prices = [],
              quantities = [];

          selectedOptions.price.each(function(index, options) {
            prices[index] = $(options).text();
          });
          selectedOptions.quantity.each(function(index, options) {
            quantities[index] = $(options).text();
          });

          return {
            price:     prices ,
            quantity:  quantities
          };
        }(),

        // 価格と個数の数字だけをとりだす。
        numberOptionContents = function() {
          var tmp,
              priceNumbers = crudeOptionContents.price.map(function(price) {
                tmp = (/\(\d+円\)/).exec(price);
                return (/\d+/).exec(tmp);
              });
          var quantityNumbers = crudeOptionContents.quantity.map(function(quantity) {
                return (/\d+/).exec(quantity);
              });

          return {
            price:    priceNumbers ,
            quantity: quantityNumbers
          };
        }(),

        //Pairの数を返す。１Pairは１つのpriceと１つのquantityのoptionからなる。
        selectPairLength = function() {
          if(selectedOptions.price.length === selectedOptions.quantity.length) {
            return selectedOptions.price.length;
          } else {
            alert('selectedOptions.price.length != selectedOptions.quantity.length');
            return 0;
          }
        }(),

        //合計を計算して、ページに反映する。
        updateTotalSum = function() {
          var i,
              sum = 0,
              calcSum = function (lockedIndex) {
                sum += numberOptionContents.price[lockedIndex] * numberOptionContents.quantity[lockedIndex];
              };

          for (i = 0; i < selectPairLength; i++) {
            calcSum(i);
          }
          $('#order_create_price_sum').text('合計: '+ sum + '円');
        }();
  });
});
