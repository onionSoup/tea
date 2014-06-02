$(function() {
  $(".name_price_options , .quantity_options").change(function() {
    var div = $("div.order_details_form"),
        option = div.find("option:selected"),
        priceAry = [],
        quantityAry = [],
        priceOptions = option.filter(".name_price_options > option"),
        quantityOptions = option.filter(".quantity_options > option"),
        totalSum = 0,
        selectpairLength = 0;
    if(priceOptions.length == quantityOptions.length) {
      selectpairLength = priceOptions.length;
    } else {
      console.log("priceOptions.length != quantityOptions.length");
      return;
    }
    for (var i =0; i < selectpairLength; i++){
      (function(lockedIndex){
        var tmpPrice = 0,
            tmpQuantity = 0;
        tmpPrice = priceOptions.eq(lockedIndex);
        tmpQuantity = quantityOptions.eq(lockedIndex);
        priceAry[lockedIndex] = tmpPrice;
        quantityAry[lockedIndex] = tmpQuantity;
      })(i);
    }
    for (var i = 0; i < selectpairLength; i++){
      (function(lockedIndex){
        var price_japanese = priceAry[lockedIndex].text(),
            quantity_japanese = quantityText = quantityAry[lockedIndex].text(),
            priceYenRegex = /\(\d+円\)/,
            priceRegex = /\d+/,
            priceNumberWithYen,
            priceNumberStr,
            quantityStr,
            quantityRegex = /\d+/;
        priceNumberWithYen = priceYenRegex.exec(price_japanese);
        priceNumberStr = priceRegex.exec(priceNumberWithYen);
        quantityStr = quantityRegex.exec(quantity_japanese);
        totalSum += priceNumberStr * quantityStr;
      })(i);
    }
    $("#order_create_price_sum").text("合計: "+ totalSum + "円");
  });
});

