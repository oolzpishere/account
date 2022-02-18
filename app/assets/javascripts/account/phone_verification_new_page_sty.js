var PhoneVerificationNewPageSty = function(){
  this.phone = document.querySelector("#phone");
  this.send_verification_code_btn = document.querySelector("#send_verification_code");
  this.count_down_text = document.querySelector("#count-down-text");

  this.verification_code = document.querySelector("#verification_code")
  this.verification_details = document.querySelector("#verification_details")

  this.error_mobile_label = document.querySelector("#error_mobile_label");
  this.error_code_label = document.querySelector("#error_code_label")

  this.submit_verification_btn = document.querySelector("#submit_verification_btn")
}

PhoneVerificationNewPageSty.prototype.phoneBlockStyle = function(){
  this.send_verification_code_btn.classList.add('disabled')
  this.phone.setAttribute("readOnly", true);
}

PhoneVerificationNewPageSty.prototype.removePhoneBlockStyle = function(){
  this.send_verification_code_btn.classList.remove('disabled')
  this.phone.setAttribute("readOnly", false);

  this.count_down_text.textContent = "";
}

PhoneVerificationNewPageSty.prototype.setValidInputStyle = function(input_field){
  input_field.classList.remove( "is-invalid" );
  input_field.classList.add( "is-valid" );
}

PhoneVerificationNewPageSty.prototype.setInvalidInputStyle = function(input_field){
  input_field.classList.remove( "is-valid" );
  input_field.classList.add( "is-invalid" );
}

PhoneVerificationNewPageSty.prototype.phoneElemsSuccessSet = function(){
  this.setValidInputStyle( this.phone );
  this.error_mobile_label.style.display = "none";
  this.error_code_label.style.display = "none";
}

PhoneVerificationNewPageSty.prototype.phoneElemsFailSet = function(error_message){
  this.setInvalidInputStyle( this.phone )
  this.error_mobile_label.textContent = error_message;
  this.error_mobile_label.style.display = "block";
}

PhoneVerificationNewPageSty.prototype.verifyAndSubmitElemsShow = function(){
  this.verification_details.style.display = "block";
  this.verification_code.value = '';
  // this.verification_code.focus();
  this.submit_verification_btn.style.display = "block";
}
