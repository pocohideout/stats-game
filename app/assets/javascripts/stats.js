// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
var validationHandler = function(){
  if($("#new_stat").length){
    $("#new_stat").validate({
      debug: false,
      rules: {
        "stat[question]": {required: true, minlength: 20, maxlength: 180},
        "stat[answer]": {required: true, number: true, min: 0, max: 9999999},
        "stat[source]": {maxlength: 100},
        "stat[year]": {number: true, min: 1500, max: new Date().getFullYear()},
        "stat[link]": {url: true, maxlength: 300}
      },
      messages:{
        "stat[question]":{minlength: "Question is too short"},
        "stat[year]":{number: "Please enter a valid year (YYYY)"}
      },
      errorElement: "span",
      highlight: function(element, errorClass, validClass){
        $(element).addClass(errorClass).removeClass(validClass);
        $(element.form).find("label[for=" + element.id + "]").addClass(errorClass);
      },
      unhighlight: function(element, errorClass, validClass){
        $(element).removeClass(errorClass).addClass(validClass);
        $(element.form).find("label[for=" + element.id + "]").removeClass(errorClass);
      }
    });
    
    $('#new_stat input[name=commit]').click(function(){
      if(!$('#new_stat').valid()){
        return false;
      }
      
      var question = $('#new_stat textarea[name="stat[question]"]').val();
      var list;
      var submit = true;
      var request = $.ajax({
        type: 'GET',
        url: '/stats/similar',
        async: false,
        dataType: 'json',
        data: {question: question},
        success: function(data) {
          list = data['list'];

          if(list.length == 0){
            return;
          }

          var msg = 'Your question may be similar to others that already exist:\n';
          var i;
          for(i=0; i < list.length; i++){
            msg += (i+1) + '. ' + list[i] + '\n';
          }
          msg += '\nAre you sure you want to save this question?\n';
          msg += 'Q. ' + question;
          submit = confirm(msg);
        }
      });

      return submit;
    });
  }
};

$(document).ready(validationHandler);
$(document).on("page:load", validationHandler);