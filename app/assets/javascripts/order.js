$(function() {
  $(".name_price_options , .quantity_options").change( function() {
    var div = $("div.order_details_form");
    var option = div.find("option:selected");
    var priceAry = [];
    var quantityAry = [];
    var priceFil = option.filter(".name_price_options > option");
    var quantityFil = option.filter(".quantity_options > option");
    var tmpPrice = 0;
    var tmpQuantity = 0;
    var totalSum = 0;
    var selectPearLength = 0;
    var price_yen_regex = /\(\d+円\)/;
    var price_regex = /\d+/;
    var price_number_with_yen;
    var price_number_str;
    var quantity_regex = /\d+/;

    if( priceFil.length == quantityFil.length ){
      selectPearLength = priceFil.length;
    }
    else {
      consol.log("priceFil.length != quantityFil.length");
      return;
    }
    for (var i =0; i < selectPearLength; i++){
      (function( lockedIndex ){
        tmpPrice = priceFil.eq(lockedIndex);
        tmpQuantity = quantityFil.eq(lockedIndex);
        priceAry.push(tmpPrice);
        quantityAry.push(tmpQuantity);
      })( i );
    }

    for (var i = 0; i < selectPearLength; i++){
      (function( lockedIndex ){
        tmpPrice = priceAry[ lockedIndex ].text();
        price_number_with_yen = price_yen_regex.exec(tmpPrice);
        price_number_str = price_regex.exec(price_number_with_yen);
        tmpQuantity = quantityAry[ lockedIndex ].text();
        quantity_str = quantity_regex.exec(tmpQuantity);
        totalSum += price_number_str * quantity_str;
      })( i );
    }

    $( "#order_create_price_sum" ).text("合計: "+ totalSum + "円" );
  });
});

