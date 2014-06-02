$(function() {
  $('.name_price_options , .quantity_options').change(function() {
    var div = $('div.order_details_form'),
        selectedOptions = div.find('option:selected'),
        priceAry = [],
        quantityAry = [],
        priceOptions = selectedOptions.filter('.name_price_options > option'),
        quantityOptions = selectedOptions.filter('.quantity_options > option'),
        totalSum = 0,
        selectPairLength = 0;
    if(priceOptions.length == quantityOptions.length) {
      selectPairLength = priceOptions.length;
    } else {
      console.log('priceOptions.length != quantityOptions.length');
      return;
    }
    for (var i =0; i < selectPairLength; i++) {
      (function(lockedIndex) {
        var tmpPrice = 0,
            tmpQuantity = 0;
        tmpPrice = priceOptions.eq(lockedIndex);
        tmpQuantity = quantityOptions.eq(lockedIndex);
        priceAry[lockedIndex] = tmpPrice;
        quantityAry[lockedIndex] = tmpQuantity;
      })(i);
    }
    for (var j = 0; j < selectPairLength; j++) {
      (function(lockedIndex) {
        var priceJapanese = priceAry[lockedIndex].text(),
            quantityJapanese = quantityText = quantityAry[lockedIndex].text(),
            priceYenRegex = /\(\d+円\)/,
            priceRegex = /\d+/,
            priceNumberWithYen,
            priceNumberStr,
            quantityStr,
            quantityRegex = /\d+/;
        priceNumberWithYen = priceYenRegex.exec(priceJapanese);
        priceNumberStr = priceRegex.exec(priceNumberWithYen);
        quantityStr = quantityRegex.exec(quantityJapanese);
        totalSum += priceNumberStr * quantityStr;
      })(j);
    }
    $('#order_create_price_sum').text('合計: '+ totalSum + '円');
  });
});

