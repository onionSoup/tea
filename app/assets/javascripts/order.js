$(function() {
  $(".name_price_options , .quantity_options").change(function() {
    var div = $("div.order_details_form"),
        option = div.find("option:selected"),
        priceAry = [],
        quantityAry = [],
        priceOptions = option.filter(".name_price_options > option"),
        quantityOptions = option.filter(".quantity_options > option"),
        totalSum = 0,
        selectPearLength = 0;
    if(priceOptions.length == quantityOptions.length) {
      selectPearLength = priceOptions.length;
    } else {
      console.log("priceOptions.length != quantityOptions.length");
      return;
    }
    for (var i =0; i < selectPearLength; i++){
      (function(lockedIndex){
        var tmpPrice = 0,
            tmpQuantity = 0;
        tmpPrice = priceOptions.eq(lockedIndex);
        tmpQuantity = quantityOptions.eq(lockedIndex);
        priceAry[lockedIndex] = tmpPrice;
        quantityAry[lockedIndex] = tmpQuantity;
      })(i);
    }
    for (var i = 0; i < selectPearLength; i++){
      (function(lockedIndex){
        var priceText = 0,
            quantityText = 0,
            priceYenRegex = /\(\d+円\)/,
            priceRegex = /\d+/,
            priceNumberWithYen,
            priceNumberStr,
            quantityStr,
            quantityRegex = /\d+/;
        priceText = priceAry[lockedIndex].text();
        priceNumberWithYen = priceYenRegex.exec(priceText);
        priceNumberStr = priceRegex.exec(priceNumberWithYen);
        quantityText = quantityAry[lockedIndex].text();
        quantityStr = quantityRegex.exec(quantityText);
        totalSum += priceNumberStr * quantityStr;
      })(i);
    }
    $("#order_create_price_sum").text("合計: "+ totalSum + "円");
  });
});

