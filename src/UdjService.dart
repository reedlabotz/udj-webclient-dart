part of udjlib;

/**
 * The udj service that talks to the server.
 */
class UdjService {
  /// The session struct that holds current session information
  Session _session;
  
  /// callback to be called if an unauthorized call happens
  final Function _loginNeeded;
  
  /**
   * Basic constructor. [_loginNeeded] should be a callback function 
   * that prompts for user to authenticate.
   */
  UdjService(this._loginNeeded);
  
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
        _session = new Session(token, user_id, username);
        callback(true);
      }else{
        callback(false);
      }
    });
    request.send(data);
  }
  
  
}
