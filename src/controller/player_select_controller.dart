library player_select_controller;

import "dart:html";
import "dart:json";
import "../view/app_view.dart";
import "../view/player_select_view.dart";
import "../model/session_model.dart";

class PlayerSelectController {
  SessionModel _session_model;
  AppView _app_view;
  PlayerSelectView _player_select_view;
  Element _current_player_btn;
  
  PlayerSelectController(AppView app_view, SessionModel session_model){
    this._app_view = app_view;
    this._app_view.register_on_player_select(this.player_change_clicked);
    this._session_model = session_model;
    
    Element box = query("#player-select-box");
    this._player_select_view = new PlayerSelectView(box);
    this._player_select_view.register_join_btn_clicked(join_btn_clicked);
  }
  
  void player_change_clicked(){
    this._player_select_view.show();
    Element loading = new ParagraphElement();
    loading.text = "Loading...";
    this._player_select_view.set_content(loading);
    this.get_location(this.load_players);
  }
  
  void join_btn_clicked(String id,data){
    this._session_model.auth_put_request('/players/${id}/users/user',{},(req) => this.finished_join_player(req,data));
  }
  
  void finished_join_player(HttpRequest request, Map data){
    if(request.status == 201){
      this._player_select_view.hide();
      this._session_model.player = data;
      this._app_view.set_player_name(this._session_model.player['name']);
    }else{
      this._app_view.throwError("Error joining player");
    }
  }
  
  void load_players(Geoposition position){
    this._session_model.auth_get_request('/players/${position.coords.latitude}/${position.coords.longitude}',{},this.finish_load_players);
  }
  
  void finish_load_players(HttpRequest request){
    List players = JSON.parse(request.responseText);
    this._player_select_view.list_players(players);
  }
  
  void get_location(Function callback){
    window.navigator.geolocation.getCurrentPosition(callback, 
        (e) => this._app_view.throwError("Geolocation must be enabled on your browser to use UDJ."), 
        null);
  }
}
