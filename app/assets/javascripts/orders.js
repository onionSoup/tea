$(function (){
  $(".include_ul").hover(
    function() {
      ul = $(this).find('ul');
      $(ul).attr('id', 'enabled_ul');
    }, function() {
      ul = $(this).find('ul');
      $(ul).attr('id', 'disabled_ul');
    }
  );
});
