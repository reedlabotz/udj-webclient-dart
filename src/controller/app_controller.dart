#library('app_controller');
#import('login_controller.dart');
#import('../model/session_model.dart');

class AppController {
  LoginController login_controller;
  SessionModel session_model;
  
  AppController(){
    this.session_model = new SessionModel();
    login_controller = new LoginController(this.session_model);
  }
}
