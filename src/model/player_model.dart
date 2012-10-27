library player_model;

import 'dart:html';
import 'dart:json';
import 'session_model.dart';

class PlayerModel {
  SessionModel _session_model;
  List queue;
  Map now_playing;
  String state;
  
  PlayerModel(SessionModel session_model){
    this._session_model = session_model;
  }
  
  void update(Function callback){
    this._session_model.auth_get_request('/players/${this._session_model.player['id']}/active_playlist',
        {},(request) => _update_finished(request, callback));
  }
  
  void _update_finished(HttpRequest request, Function callback){
    Map data = JSON.parse(request.responseText);
    this.queue = data['active_playlist'];
    this.now_playing = data['current_song'];
    this.state = data['state'];
    callback();
  }
  
  void upvote(String id, Function callback){
    this._session_model.auth_put_request('/players/${this._session_model.player['id']}/active_playlist/songs/${id}/upvote', 
        {}, (request) => callback());
  }
  
  void downvote(String id, Function callback){
    this._session_model.auth_put_request('/players/${this._session_model.player['id']}/active_playlist/songs/${id}/downvote', 
        {}, (request) => callback());
  }
  
}
