$(document).ready(function() {
  var clip = new ZeroClipboard($("#d_clip_button"))

  //configure for linux
  ZeroClipboard.config({
    forceEnhancedClipboard: true
  });

  $("#d_clip_button").hover(
    function() {
      $(".copy_tooltip").css("display", "block")
    } ,
    function() {
      $(".copy_tooltip").css("display", "none")
    }
  )
  $("#d_clip_button").click(
    function() {
      $(".copy_tooltip").text("クリップボードにコピーしました。")
    }
  )
  $("#d_clip_button").mouseout(
    function() {
      $(".copy_tooltip").text("クリップボードにコピーできます。")
    }
  )
});
