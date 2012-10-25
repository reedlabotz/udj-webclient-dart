#library('app_controller');
#import("dart:html");
#import('login_controller.dart');
#import('../model/session_model.dart');
#import('../view/app_view.dart');

class AppController {
  LoginController login_controller;
  SessionModel session_model;
  AppView app_view;
  
  AppController(){
    this.session_model = new SessionModel();
    
    this.login_controller = new LoginController(this.session_model);
    this.login_controller.register_on_logged_in(on_loggin);
   
    Element top_bar = query("#top-bar");
    Element main_content = query("#main-content");
    this.app_view = new AppView(top_bar,main_content);
    this.app_view.register_on_logged_out(this.logout_clicked);
  }
  
  void init(){
    this.login_controller.init(); 
  }
  
  void on_loggin(){
    this.app_view.setUsername(this.session_model.username);
    this.app_view.show_logged_in_view();
  }
  
  void logout_clicked(){
    this.login_controller.logout();
    this.app_view.hide_logged_in_view();
  }
}
