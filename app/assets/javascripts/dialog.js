$(function() {
  $( "#dialog" ).dialog({ autoOpen: false });
  $( "#opener" ).click(function() {
      $( "#dialog" ).dialog( "open" );
  });
});
