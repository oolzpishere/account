$(document).on("ready page:load turbolinks:load", function() {

  if ( $("#send_verification_code").length > 0 ) {
    sendVerificationCodeClickBinding();
    var page_sty = new PhoneVerificationNewPageSty();
    var countDownInterval;
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
      // block phone input and send btn, then send ajax, incase user click send btn multiple times.
      countDown( seconds );

      $.ajax({
        data: "verification_phone=" + phone_string,
        type: "get",
        url: "/sendverification",
        success: function(data) {
          if (data.result === true) {
            page_sty.phoneElemsSuccessSet();
            page_sty.verifyAndSubmitElemsShow();
          } else {
            // error_message = "problem_sending_sms";
            page_sty.phoneElemsFailSet(data.error_message)
            stopCountDown();
          }
        },
        error: function(data) {
          page_sty.phoneElemsFailSet("problem_sending_request")
          stopCountDown();
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

  function countDown( seconds ){
    page_sty.phoneBlockStyle();
    setCountDownInterval( seconds );
  }

  function stopCountDown(){
    clearCountDownInterval();
    page_sty.removePhoneBlockStyle();
  }

  function clearCountDownInterval(){
    clearInterval(countDownInterval);
  }

  function setCountDownInterval( seconds ) {
    var send_again_text = '再次发送验证码';
    page_sty.count_down_text.text(send_again_text + " (" + seconds + ")");

    countDownInterval = setInterval( function() {
      page_sty.count_down_text.text(send_again_text + " (" + --seconds + ")");
      if (seconds <= 0) {
        page_sty.removePhoneBlockStyle();
        clearCountDownInterval();
      }
    }, 1000);
  }

  function validatePhone( phone_string ) {
    if ( isValidatePhone( phone_string ) ) {
      return true;
    } else {
      page_sty.setInvalidInputStyle( page_sty.verification_phone )
      page_sty.error_mobile_label.text('号码格式不正确，请重新输入11位数字电话号码');
      page_sty.error_mobile_label.show();
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

});
