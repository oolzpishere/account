$(document).on("ready page:load turbolinks:load", function() {
  var interval;
  $("#verification_code").bind("keyup", function() {
    var data;

    function isValideCode(code_string) {
      code_string.length == 6
    }

    if ( !isValideCode( $(this).val() ) ) {
      $("#error_code_label").show();
      $("#success_code_label").hide();
      return false;
    }
  });

  $("#send_verification_code").click(function() {
    var time, seconds, phone_string;

    phone_string = $("#verification_phone").val();

    if ( !validatePhone( phone_string ) ) {
      setInvalidInputStyle( $("#verification_phone") )
      $("#error_mobile_label").text('号码格式不正确，请重新输入11位数字');
      $("#error_mobile_label").show();
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
          send_verification_code_success();
        } else {
          // $("#error_mobile_label").text('shared.navbar.problem_sending_sms'.show());
          var error_message;
          if (data.error_message) {
            error_message = data.error_message;
          } else {
            error_message = "problem_sending_sms";
          }
          setInvalidInputStyle( $("#verification_phone") )
          $("#error_mobile_label").text(error_message);
          $("#error_mobile_label").show();
        }
      },
      error: function(data) {
        setInvalidInputStyle( $("#verification_phone") )
        $("#error_mobile_label").text("problem_sending_request");
        $("#error_mobile_label").show();
      }
    });
  });

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

  function setValidInputStyle(input_field){
    input_field.removeClass( "is-invalid" );
    input_field.addClass( "is-valid" );
  }

  function setInvalidInputStyle(input_field){
    input_field.removeClass( "is-valid" );
    input_field.addClass( "is-invalid" );
  }

  function validatePhone(phone_string) {
    if (phone_string && phone_string.length === 11) {
      return true;
    } else {
      return false;
    }
  }

  function send_verification_code_success(){
    $("#verification_details").show();
    setValidInputStyle( $("#verification_phone") );
    $("#error_mobile_label").hide();
    $("#error_code_label").hide();
    $("#verification_code").val('');
    $("#verification_code").focus();
    $("#submit_verification_btn").show();
  }

});
