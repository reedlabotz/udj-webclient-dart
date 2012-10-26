library player_controller;

import 'dart:html';
import 'dart:isolate';
import 'dart:json';
import '../view/player_view.dart';
import '../model/session_model.dart';
import '../view/app_view.dart';
import '../constants.dart';

class PlayerController {
  PlayerView _player_view;
  SessionModel _session_model;
  AppView _app_view;
  Timer _queue_timer = null;
  
  PlayerController(AppView app_view, SessionModel session_model){
    this._app_view = app_view;
    this._session_model = session_model;
    this._player_view = new PlayerView(query("#player-box"));
    this._player_view.register_downvote_callback(this._downvote_song);
    this._player_view.register_upvote_callback(this._upvote_song);
  }
  
  void reload(){
    if(this._queue_timer != null){
      this._queue_timer.cancel();
    }
    this._queue_timer = new Timer.repeating(POLL_INTERVAL,this._load_queue);
    this._load_queue(null);
  }
  
  void _load_queue(Timer t){
    this._session_model.auth_get_request('/players/${this._session_model.player['id']}/active_playlist',{},_load_queue_finished);
  }
  
  void _load_queue_finished(HttpRequest request){
    Map data = JSON.parse(request.responseText);
    this._player_view.set_current(data['current_song']);
    this._player_view.set_state(data['state']);
    this._player_view.set_queue(data['active_playlist']);
  }
  
  void _upvote_song(String id){
    this._session_model.auth_put_request('/players/${this._session_model.player['id']}/active_playlist/songs/${id}/upvote', 
        {}, this._upvote_song_finished);
  }
  
  void _upvote_song_finished(HttpRequest request){
    
  }
  
  void _downvote_song(String id){
    this._session_model.auth_put_request('/players/${this._session_model.player['id']}/active_playlist/songs/${id}/downvote', 
        {}, this._downvote_song_finished);
  }
  
  void _downvote_song_finished(HttpRequest request){
    
  }
}
