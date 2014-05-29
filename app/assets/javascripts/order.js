//getElementするまで共通なので切り出す
function getPriceQuantityElements(i){
  var index_str = 0,
      price_id = 0,
      quantity_id = 0,
      price_element = 0,
      quantity_element = 0,
      elements = 0;

  index_str = i.toString();
  price_id = "order_order_details_attributes_" + index_str + "_item_id";
  quantity_id = "order_order_details_attributes_" + index_str + "_quantity";
  price_element = document.getElementById(price_id);
  quantity_element = document.getElementById(quantity_id);
  elements = [price_element,quantity_element];
  return elements;
}

//addEventListener
window.onload = function(){
  for (var i = 0; i < order_details_size; i++) {
    elements = getPriceQuantityElements(i);
    price_element = elements[0];
    quantity_element = elements[1];
    price_element.addEventListener("change", calc, false);
    quantity_element.addEventListener("change", calc, false);
  }
};

//合計取得を計算する
function calc(){
  var sum = 0,
      price_index = 0,
      quantity_index = 0,
      price_text = 0,
      quantity_text = 0,
      price_yen_regex = 0,
      price_regex = 0,
      price_number_str =0,
      price_number = 0,
      quantity_regex = 0,
      quantity_str = 0,
      quantity_number =0;

  for (var i = 0; i < order_details_size; i++) {
    price_element = getPriceQuantityElements(i)[0];
    quantity_element = getPriceQuantityElements(i)[1];
    price_index = price_element.selectedIndex;
    quantity_index = quantity_element.selectedIndex;
    price_text = price_element.options[price_index].text;
    quantity_text = quantity_element.options[quantity_index].text;

    price_yen_regex = /\(\d+円\)/;
    price_number_with_yen = price_yen_regex.exec(price_text);
    price_regex = /\d+/;
    price_number_str = price_regex.exec(price_number_with_yen);
    price_number = Number(price_number_str);

    quantity_regex = /\d+/;
    quantity_str = quantity_regex.exec(quantity_text);
    quantity_number = Number(quantity_str);
    sum += price_number * quantity_number;
  }
  total = sum.toString();
  total = '合計：' + total + '円';
  document.getElementById("order_create_price_sum").textContent = total;
}




