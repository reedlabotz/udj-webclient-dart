library app_view;

import 'dart:html';

class AppView {
  Element _top_bar;
  Element _username_holder;
  Element _main_content;
  Element _logout_button;
  Element _player_select;
  Function _logged_out_callback;
  Function _player_select_callback;
  
  AppView(Element top_bar, Element main_content){
    this._top_bar = top_bar;
    this._main_content = main_content;
    this._username_holder = top_bar.query("#username");
    this._logout_button = top_bar.query("#logout");
    this._logout_button.on.click.add((e) => this._logged_out_callback());
    this._player_select = top_bar.query("#player-select");
    this._player_select.on.click.add((e) => this._player_select_callback());
  }
  
  void show_logged_in_view(){
    this._top_bar.style.display = "block";
    this._main_content.style.display = "block";
  }
  
  void hide_logged_in_view(){
    this._top_bar.style.display = "none";
    this._main_content.style.display = "none";
  }
  
  void setUsername(String username){
    this._username_holder.text = username;
  }
  
  void set_player_name(String name){
    this._player_select.query("#current-player").text = name;
  }
  
  void register_on_logged_out(Function callback){
    this._logged_out_callback = callback;
  }
  
  void register_on_player_select(Function callback){
    this._player_select_callback = callback;
  }
  
  void throwError(String message){
    window.alert(message);
  }
}
