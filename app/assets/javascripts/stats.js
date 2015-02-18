// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
var validationHandler = function(){
  if ($("#new_stat").length){
    $("#new_stat").validate({
      debug: true,
      rules: {
        "stat[question]": {required: true, minlength: 20},
        "stat[answer]": {required: true, number: true, min: 0},
        "stat[year]": {number: true, min: 1500, max: new Date().getFullYear()},
        "stat[link]": {url: true}
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
  }
};

$(document).ready(validationHandler);
$(document).on("page:load", validationHandler);