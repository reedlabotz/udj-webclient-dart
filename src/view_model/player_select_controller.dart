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
  Function _player_selected_callback;
  
  PlayerSelectController(AppView app_view, SessionModel session_model){
    this._app_view = app_view;
    this._app_view.register_on_player_select(this.player_change_clicked);
    this._session_model = session_model;
    
    Element box = query("#player-select-box");
    this._player_select_view = new PlayerSelectView(box);
    this._player_select_view.register_join_btn_clicked(join_btn_clicked);
    this._player_select_view.register_search_callback(this.load_search);
  }
  
  void register_on_player_selected(Function callback){
    this._player_selected_callback = callback;
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
  
  void load_search(String query) {
    this._session_model.auth_get_request('/players', 
        {'name':query}, this._load_search_finished);
  }
  
  void _load_search_finished(HttpRequest request) {
    List data = JSON.parse(request.responseText);
    this._player_select_view.list_players(data);
  }
    
  void finished_join_player(HttpRequest request, Map data){
    //201 means success, 400 means you own it
    if(request.status == 201 || request.status == 400){
      this._player_select_view.hide();
      this._session_model.player = data;
      this._player_selected_callback();
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
