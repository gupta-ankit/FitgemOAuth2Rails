$(init);

function init(){
  var editor;
  if(user_signed_in){
    editor = CodeMirror.fromTextArea(document.getElementById('api_output'), {
      mode: "application/ld+json",
      lineNumbers: true
    })
  }

  $('#api-request-btn').on('click', function(){

    $.ajax({
      url: activitiy_request_url,
      dataType: 'json',
      success: function(data){
        editor.setValue(JSON.stringify(data, null, 2));
      },
      error: function(err){
        console.error(err);
      }
    });

  });
}
