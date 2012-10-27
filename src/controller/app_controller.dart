library app_controller;

import "dart:html";
import 'login_controller.dart';
import 'player_select_controller.dart';
import 'player_controller.dart';
import 'library_controller.dart';
import '../model/session_model.dart';
import '../view/app_view.dart'  ;

class AppController {
  LoginController login_controller;
  PlayerSelectController player_select_controller;
  PlayerController player_controller;
  LibraryController library_controller;
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
    
    this.player_select_controller = new PlayerSelectController(this.app_view,this.session_model);
    this.player_select_controller.register_on_player_selected(this.on_player_selected);
    
    this.player_controller = new PlayerController(this.app_view,this.session_model);
    
    this.library_controller = new LibraryController(this.app_view,this.session_model);
  }
  
  void init(){
    this.login_controller.init(); 
  }
  
  void on_loggin(){
    this.app_view.setUsername(this.session_model.username);
    this.app_view.show_logged_in_view();
    if(this.session_model.player != null){
      this.on_player_selected();
    }else{
      this.player_select_controller.player_change_clicked();
    }
  }
  
  void on_player_selected(){
    this.app_view.set_player_name(this.session_model.player['name']);
    this.player_controller.init();
    this.library_controller.load_random();
  }
  
  void logout_clicked(){
    this.login_controller.logout();
    this.app_view.hide_logged_in_view();
  }
}
