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
  
  void getRandomLibrary(String playerId,Function callback){
    auth_get_request('/players/${playerId}/available_music/random_songs', 
        {'max_randoms':'50'}, (HttpRequest request){
          List data = JSON.parse(request.responseText);
          callback({'success':true,'data':data});
        });
  }
  
  /**
   * A GET request with auth token.
   */
  void auth_get_request(String url,Map data,Function callback){
    HttpRequest request;
    request = new HttpRequest();
    String query = RequestHelper.encodeMap(data);
    request.open("GET",'${Constants.API_URL}${url}?${query}');
    this.auth_request(request, null, callback);
  }
  
  /**
   * A PUT request with auth token.
   */
  void auth_put_request(String url,Map data,Function callback){
    HttpRequest request;
    request = new HttpRequest();
    String query = RequestHelper.encodeMap(data);
    request.open("PUT",'${Constants.API_URL}${url}');
    request.setRequestHeader('Content-type', 'application/x-www-form-urlencode');
    this.auth_request(request, query, callback);
  }
  
  /**
   * A POST request with auth token
   */
  void auth_post_request(String url,Map data,Function callback){
    HttpRequest request;
    request = new HttpRequest();
    String query = RequestHelper.encodeMap(data);
    request.open("POST",'${Constants.API_URL}${url}');
    request.setRequestHeader('Content-type', 'application/x-www-form-urlencode');
    this.auth_request(request, query, callback);
  }
  
  /**
   * A request with auth token.
   */
  void auth_request(HttpRequest request,String body,Function callback){
    request.on.loadEnd.add((e){
      // Check that we don't have to re-auth
      if(request.status == 401){
        _loginNeeded();
      }else{
        callback(request);
      }
    });
    request.setRequestHeader('X-Udj-Ticket-Hash',session.value.ticket_hash);
    if(body == null){
      request.send();
    }else{
      request.send(body);
    }
  }
  
  
}
