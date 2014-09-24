$(function() {
  const spaceBetweenSelectAndSubmit = 15;
  var selecterSpace =  parseInt($( 'select' ).css('width')) +  parseInt($( 'select' ).css('left')) + spaceBetweenSelectAndSubmit;
  $('input[type=submit]').css('left', selecterSpace);
});
