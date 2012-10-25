#library("login_controller");
#import("dart:html");
#import('../view/login_view.dart');
#import('../model/session_model.dart');

class LoginController {
  LoginView login_view;
  SessionModel session_model;
  
  LoginController(SessionModel session_model){
    this.session_model = session_model;
    Element login_box = query("#login-box");
    this.login_view = new LoginView(login_box);
    this.login_view.register_submitted_callback(this.login);
  }
  
  void login_finished(bool success){
    if(success){
      this.login_view.hide();
    }else{
      this.login_view.show_error();
    }
  }
  
  void login(){
    String username = this.login_view.getUsername();
    String password = this.login_view.getPassword();
    this.session_model.login(username, password,login_finished);
  }
}
