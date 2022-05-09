var ready = (callback) => {
  if (document.readyState != "loading") callback();
  else document.addEventListener("DOMContentLoaded", callback);
}

ready(() => {

  let login_container_id = 'login_container';
  var login_container = document.getElementById(login_container_id);
  var state = login_container.getAttribute('data-state');
  var redirect_url = "https://www.sflx.com.cn/get-weixin-code.html?redirect_uri=" + window.location.protocol + "//" + window.location.host + "/auth/open_wechat/redirect"
  console.log(state);

  var obj = new WxLogin({
    self_redirect: true,
    id: login_container_id,
    appid: "wx4368756ad44ab8c0",
    scope: "snsapi_login",
    redirect_uri: redirect_url,
    state: state
    // style: "",
    // href: ""
  });

  
})