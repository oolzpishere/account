$(document).on("ready page:load turbolinks:load", function() {
  var interval;

  if ( $("#send_verification_code").length > 0 ) {
    sendVerificationCodeClickBinding();
  }

  function sendVerificationCodeClickBinding(){
    $("#send_verification_code").click(function() {
      var time, seconds, phone_string;

      phone_string = $("#verification_phone").val();

      if ( !validatePhone( phone_string ) ) {
        return;
      }

      time = 30000;
      seconds = Math.ceil(time / 1000);

      // countDown( $(this), seconds )

      $.ajax({
        data: "verification_phone=" + phone_string,
        type: "get",
        url: "/sendverification",
        success: function(data) {
          if (data.result === true) {
            phoneElemsSuccessSet();
            verifyAndSubmitElemsShow();
          } else {
            // error_message = "problem_sending_sms";
            phoneElemsFailSet(data.error_message)
          }
        },
        error: function(data) {
          phoneElemsFailSet("problem_sending_request")
        }
      });
    });
  }

  if ( $("#verification_code".length > 0) ) {
    veriCodeBind();
  }

  function veriCodeBind(){
    $("#verification_code").bind("keyup", function() {
      var data;
      if ( !isValideCode( $(this).val() ) ) {
        $("#error_code_label").show();
        $("#success_code_label").hide();
        return;
      }
    });
  }

  function isValideCode(code_string) {
    code_string.length == 6
  }

  function countDown(obj, seconds){
    obj.each(function() {
      var disabled_elem, new_text;
      disabled_elem = obj;
      $("#verification_phone").prop("disabled", true);
      disabled_elem.prop("disabled", true);
      new_text = 'shared.navbar.send_code_again';
      disabled_elem.val(new_text + " (" + seconds + ")");
      interval = setInterval(function() {
        disabled_elem.val(new_text + " (" + --seconds + ")");
        if (seconds === 0) {
          $("#verification_phone").prop("disabled", false);
          disabled_elem.prop("disabled", false);
          disabled_elem.val(new_text);
          clearInterval(interval);
        }
      }, 1000);
    });
  }


  function validatePhone(phone_string){
    if ( isValidatePhone( phone_string ) ) {
      return true;
    } else {
      setInvalidInputStyle( $("#verification_phone") )
      $("#error_mobile_label").text('号码格式不正确，请重新输入11位数字电话号码');
      $("#error_mobile_label").show();
      return false;
    }
  }

  function isValidatePhone(phone_string) {
    if (phone_string && phone_string.length === 11) {
      return true;
    } else {
      return false;
    }
  }

  function setValidInputStyle(input_field){
    input_field.removeClass( "is-invalid" );
    input_field.addClass( "is-valid" );
  }

  function setInvalidInputStyle(input_field){
    input_field.removeClass( "is-valid" );
    input_field.addClass( "is-invalid" );
  }

  function phoneElemsSuccessSet(){
    setValidInputStyle( $("#verification_phone") );
    $("#error_mobile_label").hide();
    $("#error_code_label").hide();
  }

  function phoneElemsFailSet(error_message){
    setInvalidInputStyle( $("#verification_phone") )
    $("#error_mobile_label").text(error_message).show();
  }

  function verifyAndSubmitElemsShow(){
    $("#verification_details").show();
    $("#verification_code").val('');
    $("#verification_code").focus();
    $("#submit_verification_btn").show();
  }

});
