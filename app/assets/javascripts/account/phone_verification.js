;// $(document).on("turbo:load", function() {
// Without jQuery
// Define a convenience method and use it
var ready = (callback) => {
  if (document.readyState != "loading") callback();
  else document.addEventListener("DOMContentLoaded", callback);
}

// document.addEventListener("turbo:load", (e) => {
ready(() => {
  // if ( $("#send_verification_code").length > 0 ) {
  if ( document.querySelector("#send_verification_code") ) {
    sendVerificationCodeClickBinding();
    var page_sty = new PhoneVerificationNewPageSty();
    var countDownInterval;
  }

  function sendVerificationCodeClickBinding(){
    document.querySelector("#send_verification_code").addEventListener("click", (e) => {
      var time, seconds, phone_string, user_action;

      phone_string = document.querySelector("#phone").value;
      user_action = document.querySelector("#user_action").value;

      if ( !validatePhone( phone_string ) ) {
        return;
        console.log("wrong phone str");
      }

      time = 30000;
      seconds = Math.ceil(time / 1000);
      // block phone input and send btn, then send ajax, incase user click send btn multiple times.
      countDown( seconds );

      let send_verification_url = "/send_verification?" + "phone=" + phone_string + "&user_action=" + user_action

      fetch( send_verification_url, {method: 'GET'} ).then(res => {
        res.json().then(data => {
          if (data.result === true) {
            page_sty.phoneElemsSuccessSet();
            page_sty.verifyAndSubmitElemsShow();
          } else {
            // error_message = "problem_sending_sms";
            page_sty.phoneElemsFailSet(data.error_message)
            stopCountDown();
          }
        });
      }).catch(error => {
        page_sty.phoneElemsFailSet("problem_sending_request")
        stopCountDown();
      });
      // $.ajax({
      //   data: "phone=" + phone_string + "&user_action=" + user_action,
      //   type: "get",
      //   url: "/send_verification",
      //   success: function(data) {
      //     if (data.result === true) {
      //       page_sty.phoneElemsSuccessSet();
      //       page_sty.verifyAndSubmitElemsShow();
      //     } else {
      //       // error_message = "problem_sending_sms";
      //       page_sty.phoneElemsFailSet(data.error_message)
      //       stopCountDown();
      //     }
      //   },
      //   error: function(data) {
      //     page_sty.phoneElemsFailSet("problem_sending_request")
      //     stopCountDown();
      //   }
      // });

    });
  }

  if ( document.querySelector("#verification_code") ) {
    veriCodeBind();
  }

  function veriCodeBind(){
    document.querySelector("#verification_code").addEventListener("keyup", (e) => {
      var data;
      if ( !isValideCode( document.querySelectorAll(this).val() ) ) {
        document.querySelector("#error_code_label").style.display = "block";
        document.querySelector("#success_code_label").style.display = "none";
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
    page_sty.count_down_text.textContent = (send_again_text + " (" + seconds + ")");

    countDownInterval = setInterval( function() {
      page_sty.count_down_text.textContent = (send_again_text + " (" + --seconds + ")");
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
      page_sty.setInvalidInputStyle( page_sty.phone )
      page_sty.error_mobile_label.textContent = ('号码格式不正确，请重新输入11位数字电话号码');
      page_sty.error_mobile_label.style.display = "block";
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
