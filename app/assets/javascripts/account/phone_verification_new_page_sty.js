var PhoneVerificationNewPageSty = function(){
  this.phone = $("#phone");
  this.send_verification_code_btn = $("#send_verification_code");
  this.count_down_text = $("#count-down-text");

  this.verification_code = $("#verification_code")
  this.verification_details = $("#verification_details")

  this.error_mobile_label = $("#error_mobile_label");
  this.error_code_label = $("#error_code_label")

  this.submit_verification_btn = $("#submit_verification_btn")
}

PhoneVerificationNewPageSty.prototype.phoneBlockStyle = function(){
  this.send_verification_code_btn.addClass('disabled')
  this.phone.prop("readOnly", true);
}

PhoneVerificationNewPageSty.prototype.removePhoneBlockStyle = function(){
  this.send_verification_code_btn.removeClass('disabled')
  this.phone.prop("readOnly", false);

  this.count_down_text.text("");
}

PhoneVerificationNewPageSty.prototype.setValidInputStyle = function(input_field){
  input_field.removeClass( "is-invalid" );
  input_field.addClass( "is-valid" );
}

PhoneVerificationNewPageSty.prototype.setInvalidInputStyle = function(input_field){
  input_field.removeClass( "is-valid" );
  input_field.addClass( "is-invalid" );
}

PhoneVerificationNewPageSty.prototype.phoneElemsSuccessSet = function(){
  this.setValidInputStyle( this.phone );
  this.error_mobile_label.hide();
  this.error_code_label.hide();
}

PhoneVerificationNewPageSty.prototype.phoneElemsFailSet = function(error_message){
  this.setInvalidInputStyle( this.phone )
  this.error_mobile_label.text(error_message).show();
}

PhoneVerificationNewPageSty.prototype.verifyAndSubmitElemsShow = function(){
  this.verification_details.show();
  this.verification_code.val('');
  this.verification_code.focus();
  this.submit_verification_btn.show();
}
