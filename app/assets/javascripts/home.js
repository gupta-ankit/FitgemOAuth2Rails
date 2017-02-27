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
      url: get_request_url(),
      dataType: 'json',
      success: function(data){
        editor.setValue(JSON.stringify(data, null, 2));
      },
      error: function(err){
        console.error(err);
      }
    });

  });

  kve = KVEditor.create($("#kveditor"))
  $("#get-call").on("click", function(){
    var url = $("input[name='resource_uri']").val();
    $.ajax({
      url: "/fitbit_api/get_call",
      data: {
        resource_uri: url,
        get_params: kve.data()
      },
      dataType: 'json',
      success: function(data){
        editor.setValue(JSON.stringify(data, null, 2));
      },
      error: function(err){
        console.error(err);
      }
    })
  });
}

function get_request_url(){
  return $("select[name='request-url'] option:selected").val()
}


KVEditor = {
  create: function(target){
    var editor = {};

    var $target = $(target);
    var $kvform = $("<div>").attr("class", "_kv_form").appendTo($target);
    var $kvbtn = $("<div>").attr("class", "_kv_btn").appendTo($target);

    $("<button>").attr({
      class: "_kv_addrow"
    }).text("Add a get url parameter")
    .on("click", function(){
      var $row = $("<div>").attr({
        class: "_kv_row"
      }).appendTo($kvform);
      $("<input>").attr("class", "_kv_key").appendTo($row);
      $("<input>").attr("class", "_kv_value").appendTo($row);
      $("<button>").text("x").on("click", function(){
        $row.remove();
      }).appendTo($row);

      editor.data();
    })
    .appendTo($kvbtn);

    editor.data = function(){
      var ret = {};
      $kvform.find("div._kv_row").each(function(){
        var key = $(this).find("input._kv_key").val();
        var value = $(this).find("input._kv_value").val();
        ret[key] = value;
      });
      return ret;
    }

    return editor;
  }
};
