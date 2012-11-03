part of udjlib;

/**
 * The udj service that talks to the server.
 */
class UdjService {
  /// The session struct that holds current session information
  final ObservableValue<Session> session;
  
  /// callback to be called if an unauthorized call happens
  final Function _loginNeeded;
  
  /**
   * Basic constructor. [_loginNeeded] should be a callback function 
   * that prompts for user to authenticate.
   */
  UdjService(this._loginNeeded):session = new ObservableValue<Session>(null);
  
  /**
   * Login the user using a [username] and [password]
   */
  void login(String username, String password, Function callback){
    HttpRequest request = new HttpRequest();
    request.open("POST", '${Constants.API_URL}/auth', true);
    String data;
    data = RequestHelper.encodeMap({'username':username,'password':password});
    request.setRequestHeader('Content-type', 'application/x-www-form-urlencode');
    request.on.loadEnd.add((e){
      if(request.status==200){
        var data = JSON.parse(request.responseText);
        var token = data['ticket_hash'];
        var user_id = data['user_id'];
        session.value = new Session(token, user_id, username);
        callback(true);
      }else{
        callback(false);
      }
    });
    request.send(data);
  }
  
  void getRandomLibrary(String playerId, Function callback){
    authGetRequest('/players/${playerId}/available_music/random_songs', 
        {'max_randoms':'50'}, (HttpRequest request){
          List data = JSON.parse(request.responseText);
          callback({'success':true,'data':data});
        });
  }
  
  void getRecentLibrary(String playerId, Function callback){
    authGetRequest('/players/${playerId}/recently_played',
        {'max_randoms':'50'}, (HttpRequest request){
          List data = JSON.parse(request.responseText);
          data = data.map((i) => i['song']);
          callback({'success':true,'data':data});
        });
  }
  
  void getSearchLibrary(String playerId, String query, Function callback){
    authGetRequest('/players/${playerId}/available_music',
        {'max_randoms':'50','query':query}, (HttpRequest request){
          List data = JSON.parse(request.responseText);
          callback({'success':true,'data':data});
        });
  }
  
  void pollPlayer(String playerId, Function callback){
    authGetRequest('/players/${playerId}/active_playlist',{},(HttpRequest request){
      callback({'success':true,'data':JSON.parse(request.responseText)});
    });
  }
  
  void voteSong(String action,String playerId, String songId, Function callback){
    authPutRequestForm('/players/${playerId}/active_playlist/songs/${songId}/${action}',{},(HttpRequest request){
      
    });
  }
  
  void addSong(String playerId, String songId, Function callback){
    authPutRequestForm('/players/${playerId}/active_playlist/songs/${songId}',{},(HttpRequest request){
      
    });
  }
  
  void getSearchPlayer(String search, Function callback){
    authGetRequest('/players',
      {'name': search, 'max_results': Constants.MAX_RESULTS},
      (HttpRequest request) {
        List data = JSON.parse(request.responseText);
        callback({'success': true, 'players': data});
      });
  }
  
  void createPlayer(Map playerAttrs, Function callback) {
    authPutRequestJson('/players/player', playerAttrs, (HttpRequest request) {
      if (request.status == 201) {
        callback({
          'success': true,
          'playerData': JSON.parse(request.responseText)
        });
      
      } else {
        String error = Errors.UNKOWN;
        //TODO: handle errors
        
        callback({'success': false, 'error': error});
        
      }
      
    });
  }
  
  void setPlayerState(String playerID, String playerState, Function callback) {
    authPostRequest("/players/$playerID/state", {'state': playerState}, (HttpRequest request) {
      if (request.status == 200) {
        callback( {'success': true} );
      }
      //TODO: else handle errors

    });
  }
  
  /**
   * 
   */
  void joinPlayer(String playerID, Function callback){
    authPutRequestForm('/players/$playerID/users/user', {}, (HttpRequest req) {
      // 201 is success, 400 is you own it
     if (req.status == 201 || req.status == 400) {
        callback( {'success': true} );
        
      } else {
        String error = Errors.UNKOWN;
        if (req.status == 403 && req.getResponseHeader('X-Udj-Forbidden-Reason') == "player-full") {
          error = Errors.PLAYER_FULL;
          
        } else if (req.status == 403 && req.getResponseHeader('X-Udj-Forbidden-Reason') == "banned") {
          error = Errors.PLAYER_BANNED;
          
        }
        
        callback({
          'success': false,
          'error': error
        });
        
      }

    });
  }
  
  /**
   * A GET request with auth token.
   */
  void authGetRequest(String url,Map data,Function callback){
    HttpRequest request;
    request = new HttpRequest();
    String query = RequestHelper.encodeMap(data);
    request.open("GET",'${Constants.API_URL}${url}?${query}');
    this.authRequest(request, null, callback);
  }
  
  /**
   * A PUT request with auth token and application/x-www-form-urlencode Content-type.
   */
  void authPutRequestForm(String url,Map data,Function callback) {
    authPutRequest(url, RequestHelper.encodeMap(data), callback, 'application/x-www-form-urlencode');
  }
  
  /**
   * A PUT request with auth token and text/json Content-type.
   */
  void authPutRequestJson(String url, Map data, Function callback) {
    authPutRequest(url, JSON.stringify(data), callback, 'text/json');
  }
  
  void authPutRequest(String url, String query, Function callback, String contentType) {
    HttpRequest request;
    request = new HttpRequest();
    request.open("PUT",'${Constants.API_URL}${url}');
    request.setRequestHeader('Content-type', contentType);
    this.authRequest(request, query, callback);
  }
  
  /**
   * A POST request with auth token
   */
  void authPostRequest(String url,Map data,Function callback){
    HttpRequest request;
    request = new HttpRequest();
    String query = RequestHelper.encodeMap(data);
    request.open("POST",'${Constants.API_URL}${url}');
    request.setRequestHeader('Content-type', 'application/x-www-form-urlencode');
    this.authRequest(request, query, callback);
  }
  
  /**
   * A request with auth token.
   */
  void authRequest(HttpRequest request,String body,Function callback){
    request.on.loadEnd.add((e){
      // Check that we don't have to re-auth
      if(request.status == 401){
        _loginNeeded();
      }else{
        callback(request);
      }
    });
    request.setRequestHeader('X-Udj-Ticket-Hash',session.value.ticketHash);
    if(body == null){
      request.send();
    }else{
      request.send(body);
    }
  }
  
  
}
