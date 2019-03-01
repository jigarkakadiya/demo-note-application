var flag = 0 , interval;
$(".alert").hide()
$("a").tooltip()
function do_autosave()
{
  var form_data = $("#note_form").serialize();
  if(flag == 0)
    type = "POST"
  else
    type = "PATCH"
  tinymce.triggerSave();
  if($("#note_title").val().length > 0){
    console.log('in autosave')
    $.ajax({
      type: type,
      url: $("#note_form").attr("action"),
      data: form_data,
      success: function(data){
        console.log(data)
        $("#note_form").attr("action", "/notes/"+ data.note_id);
        $.ajax("/notes/load_data")
        flag = 1
        setTimeout(function() {
            $(".alert").slideUp()
        }, 2000);
      }
    });//end of ajax
  }//end of if
}//end of do_autosave

$("a").click(function(){
  console.log("link clicked")
  clearInterval(interval)
})

$("#new_note").click(function(){
  flag = 0
  $("#note_form").attr("method", "POST");
});

$(".edit").click(function(){
  flag = 1
})

$(".close").click(function(){
  $(".alert").slideUp()
})
