var ready = (callback) => {
  if (document.readyState != "loading") callback();
  else document.addEventListener("DOMContentLoaded", callback);
}

ready(() => {

  let login_container_id = 'login_container';
  var login_container = document.getElementById(login_container_id);
  var state = login_container.getAttribute('data-state');

  console.log(state);

  var obj = new WxLogin({
    self_redirect: true,
    id: login_container_id,
    appid: "wx4368756ad44ab8c0",
    scope: "snsapi_login",
    redirect_uri: "https://www.sflx.com.cn/get-weixin-code.html?redirect_uri=http://localhost:3000/auth/open_wechat/redirect",
    state: state
    // style: "",
    // href: ""
  });

  
})