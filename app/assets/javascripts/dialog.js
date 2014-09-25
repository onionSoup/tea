//TODO DRYに
$(function() {
  $( "#postage_dialog" ).dialog({ autoOpen: false });
  $( "#postage_opener" ).click(function() {
      $( "#postage_dialog" ).dialog( "open" );
      $('.ui-dialog-titlebar-close').focus();
  });

  $( "#order_dialog" ).dialog({ autoOpen: false });
  $( "#order_opener" ).click(function() {
      $( "#order_dialog" ).dialog( "open" );
      $('.ui-dialog-titlebar-close').focus();
  });

  $( "#period_dialog" ).dialog({ autoOpen: false });
  $( "#period_opener" ).click(function() {
      $( "#period_dialog" ).dialog( "open" );
      $('.ui-dialog-titlebar-close').focus();
  });

  $( "#admin_period_dialog" ).dialog({ autoOpen: false });
  $( "#admin_period_opener" ).click(function() {
      $( "#admin_period_dialog" ).dialog( "open" );
      $('.ui-dialog-titlebar-close').focus();
  });
});
