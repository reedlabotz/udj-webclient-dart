library session_model;

import "dart:html";
import "dart:json";
import "dart:uri";
import "../constants.dart";


class SessionModel {
  String _token = null;
  int _user_id = null;
  String _username = null;
  Map _player = null;
  
  SessionModel(){
    if(window.localStorage.containsKey('token') 
        && window.localStorage.containsKey('user_id') 
        && window.localStorage.containsKey('username')){
      this.token = window.localStorage['token'];
      this.user_id = int.parse(window.localStorage['user_id']);
      this.username = window.localStorage['username'];
    }
    if(window.localStorage.containsKey('player')){
      this.player = JSON.parse(window.localStorage['player']);
    }
  }
  
  String get token() => _token;
  void set token(String value){
    if(value == null){
      window.localStorage.remove('token');
    }else{
      this._token = value;
      window.localStorage['token'] = value.toString();
    }
  }
  
  int get user_id() => _user_id;
  void set user_id(int value){
    if(value == null){
      window.localStorage.remove('user_id');
    }else{
      this._user_id = value;
      window.localStorage['user_id']= value.toString();
    }
  }
  
  String get username() => this._username;
  void set username(String value){
    if(value == null){
      window.localStorage.remove('username');
    }else{
      this._username = value;
      window.localStorage['username'] = value.toString();
    }
  }
  
  Map get player() => this._player;
  void set player(Map value){
    if(value == null){
      window.localStorage.remove('player');
    }else{
      this._player = value;
      window.localStorage['player'] = JSON.stringify(value);
    }
  }
  
  bool isLoggedIn(){
    return this.token != null && this.user_id != null && this.username != null;
  }
  
  
  static String encodeMap(Map data) {
    return Strings.join(data.getKeys().map((k) {
      return '${encodeUriComponent(k)}=${encodeUriComponent(data[k])}';
    }), '&');
  }
  
  void _loadEnd(HttpRequest request,Function callback){
    if(request.status==200){
      Map data = JSON.parse(request.responseText);
      this.token = data['ticket_hash'];
      this.user_id = data['user_id'];
      callback(true);
    }else{
      callback(false);
    }
  }
  
  
  bool login(String username,String password,Function callback){
    HttpRequest request = new HttpRequest();
    request.open("POST", '${API_URL}/auth', true);
    String data;
    data = encodeMap({'username':username,'password':password});
    request.setRequestHeader('Content-type', 'application/x-www-form-urlencode');
    request.on.loadEnd.add((e) => _loadEnd(request,callback));
    request.send(data);
  }
  
  void logout(){
    this.user_id = null;
    this.username = null;
    this.token = null;
  }
  
  void auth_get_request(String url,Map data,Function callback){
    HttpRequest request;
    request = new HttpRequest();
    String query = encodeMap(data);
    request.open("GET",'${API_URL}${url}?${query}');
    this.auth_request(request, null, callback);
  }
  
  void auth_put_request(String url,Map data,Function callback){
    HttpRequest request;
    request = new HttpRequest();
    String query = encodeMap(data);
    request.open("PUT",'${API_URL}${url}');
    request.setRequestHeader('Content-type', 'application/x-www-form-urlencode');
    this.auth_request(request, query, callback);
  }
  
  void auth_post_request(String url,Map data,Function callback){
    HttpRequest request;
    request = new HttpRequest();
    String query = encodeMap(data);
    request.open("POST",'${API_URL}${url}');
    request.setRequestHeader('Content-type', 'application/x-www-form-urlencode');
    this.auth_request(request, query, callback);
  }
  
  void auth_request(HttpRequest request,String body,Function callback){
    request.on.loadEnd.add((e) => callback(request));
    request.setRequestHeader('X-Udj-Ticket-Hash',this._token);
    if(body == null){
      request.send();
    }else{
      request.send(body);
    }
  }
}
