library login_controller;

import "dart:html";
import '../view/login_view.dart';
import '../model/session_model.dart';

class LoginController {
  LoginView _login_view;
  SessionModel _session_model;
  Function _on_logged_in;
  
  LoginController(SessionModel session_model){
    this._session_model = session_model;
    Element login_box = query("#login-box");
    this._login_view = new LoginView(login_box);
    this._login_view.register_submitted_callback(this._login_clicked);
  }
  
  void init(){
    if(this._session_model.isLoggedIn()){
      this._on_logged_in();
    }else{
      this._login_view.show();
    }
  }
  
  void register_on_logged_in(Function callback){
    this._on_logged_in = callback;
  }
  
  void logout(){
    this._session_model.logout();
    this._login_view.show();
  }
  
  void _login_finished(bool success){
    if(success){
      this._session_model.username = this._login_view.getUsername();
      this._login_view.hide();
      this._on_logged_in();
      this._login_view.clearInput();
    }else{
      this._login_view.show_error();
      this._login_view.clearPassword();
    }
  }
  
  void _login_clicked(){
    String username = this._login_view.getUsername();
    String password = this._login_view.getPassword();
    this._session_model.login(username, password,this._login_finished);
  }
  
  
}
