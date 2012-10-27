library player_controller;

import 'dart:html';
import 'dart:isolate';
import 'dart:json';
import '../view/player_view.dart';
import '../view/app_view.dart';
import '../model/session_model.dart';
import '../model/player_model.dart';
import '../constants.dart';

class PlayerController {
  PlayerView _player_view;
  AppView _app_view;
  SessionModel _session_model;
  PlayerModel _player_model;
  Timer _update_time = null;
  
  PlayerController(this._app_view, this._session_model){
    this._player_view = new PlayerView(query("#player-box"));
    this._player_model = new PlayerModel(this._session_model);
    
    this._registerCallbacks();
  }
  
  void init(){
    if(this._update_time != null){
      this._update_time.cancel();
    }
    this._update_time = new Timer.repeating(POLL_INTERVAL,this._updateQueue);
    this._updateQueue(null);
  }
  
  void _registerCallbacks(){
    this._player_view.register_downvote_callback(this._downvoteSong);
    this._player_view.register_upvote_callback(this._upvoteSong);
  }
  
  void _updateQueue(Timer t){
    this._player_model.update(this._playerModelUpdateFinished);
  }
  
  void _playerModelUpdateFinished(){
    this._player_view.set_current(this._player_model.now_playing);
    this._player_view.set_state(this._player_model.state);
    this._player_view.set_queue(this._player_model.queue);
  }
  
  void _upvoteSong(String id){
    this._player_model.upvote(id, this._upvoteSongFinished);
  }
  
  void _upvoteSongFinished(){
    
  }
  
  void _downvoteSong(String id){
    this._player_model.downvote(id, this._downvoteSongFinished);
  }
  
  void _downvoteSongFinished(){
    
  }
}
