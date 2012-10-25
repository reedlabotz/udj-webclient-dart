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
    login_controller = new LoginController(this.session_model);
    login_controller.register_on_logged_in(on_loggin);
    
    Element top_bar = query("#top-bar");
    Element main_content = query("#main-content");
    this.app_view = new AppView(top_bar,main_content);
  }
  
  void on_loggin(){
    this.app_view.show_logged_in();
  }
}
