library library_controller;

import 'dart:html';
import 'dart:json';
import '../view/library_view.dart';
import '../view/app_view.dart';
import '../model/session_model.dart';

class LibraryController {
  LibraryView _library_view;
  AppView _app_view;
  SessionModel _session_model;
  
  LibraryController(AppView app_view, SessionModel session_model){
    this._app_view = app_view;
    this._session_model = session_model;
    Element library_box = query("#library-box");
    this._library_view = new LibraryView(library_box);
    this._library_view.register_add_callback(this._add_song);
    this._library_view.register_random_click(this.load_random);
    this._library_view.register_recent_click(this.load_recent);
    this._library_view.register_search_click(this.load_search);
  }
  
  void load_random(){
    this._library_view.activate_random();
    this._session_model.auth_get_request('/players/${this._session_model.player['id']}/available_music/random_songs', 
        {'max_randoms':'50'}, this._load_random_finished);
  }
 
  void _load_random_finished(HttpRequest request){
    List data = JSON.parse(request.responseText);
    this._library_view.display_song_set(data);
  }
  
  void load_recent(){
    this._library_view.activate_recent();
    this._session_model.auth_get_request('/players/${this._session_model.player['id']}/recently_played', 
        {'max_randoms':'50'}, this._load_recent_finished);
  }
  
  void _load_recent_finished(HttpRequest request){
    List data = JSON.parse(request.responseText);
    List songs = [];
    for(var d in data){
      songs.add(d['song']);
    }
    this._library_view.display_song_set(songs);
  }
  
  void load_search(String query){
    this._library_view.activate_search();
    this._session_model.auth_get_request('/players/${this._session_model.player['id']}/available_music', 
        {'max_randoms':'50','query':query}, this._load_search_finished);
  }
  
  void _load_search_finished(HttpRequest request){
    List data = JSON.parse(request.responseText);
    this._library_view.display_song_set(data);
  }
  
  void _add_song(String id){
    this._session_model.auth_put_request('/players/${this._session_model.player['id']}/active_playlist/songs/${id}', 
        {}, this._add_song_finished);
  }
  
  void _add_song_finished(HttpRequest request){
    
  }
}
