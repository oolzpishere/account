$(document).on("ready page:load turbolinks:load", function() {
  var interval;
  $("#verification_code").bind("keyup", function() {
    var data;

    function isValideCode(code_string) {
      code_string.length == 6
    }

    if ( !isValideCode( $(this).val() ) ) {
      $("#error_code_label").hide();
      $("#success_code_label").hide();
      return false;
    }

    $.ajax({
      type: "POST",
      url: "/check_verification_code",
      data: "verification_code=" + $("#verification_code").val() + "&" + "verification_phone=" + $("#verification_phone").val(),
      success: function(data) {
        if (data.result === true) {
          $("#provider_business_phone").val($("#verification_phone").val());
          clearInterval(interval);
          $("#error_code_label").hide();
          $("#success_code_label").show();
          $("#verification_code").prop("disabled", true);
          $("#provider_submit").prop("value", "shared.navbar.pleasewait");
          $("#providerform").submit();
          return;
        } else {
          $("#error_code_label").text('shared.navbar.error_in_code'.show());
        }
      },
      error: function(data) {
        $("#error_code_label").text('shared.navbar.problem_sending_request'.show());
      }
    });
  });

  $("#sendverification").click(function() {
    var time, seconds, phone_string;

    phone_string = $("#verification_phone").val();

    function isAValidePhone(phone_string) {
      return(phone_string.length === 11);
    }

    if ( !isAValidePhone( phone_string ) ) {
      $("#verification_phone").addClass( "is-invalid" );
      $("#error_mobile_label").addClass( "invalid-feedback" );
      $("#error_mobile_label").text('号码格式不正确，请重新输入11位数字');
      return false;
    }

    time = 30000;
    seconds = Math.ceil(time / 1000);

    countDown( $(this), seconds)

    $.ajax({
      data: "verification_phone=" + phone_string,
      type: "get",
      url: "/sendverification",
      success: function(data) {
        if (data.result === true) {
          $("#verification_code").show();
          $("#verify_code_label").show();
          $("#error_mobile_label").hide();
          $("#error_code_label").hide();
          $("#verification_code").val('');
          $("#verification_code").focus();
        } else {
          // $("#error_mobile_label").text('shared.navbar.problem_sending_sms'.show());
          $("#error_mobile_label").text('shared.navbar.problem_sending_sms');
        }
      },
      error: function(data) {
        $("#error_mobile_label").text('shared.navbar.problem_sendbing_request');
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
});
