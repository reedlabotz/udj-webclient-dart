#library("session_model");
#import("dart:html");
#import("dart:json");
#import("dart:uri");
#import("../constants.dart");


class SessionModel {
  String token;
  int user_id;
  
  SessionModel(){
    
  }
  
  static String encodeMap(Map data) {
    return Strings.join(data.getKeys().map((k) {
      return '${encodeUriComponent(k)}=${encodeUriComponent(data[k])}';
    }), '&');
  }
  
  void loadEnd(HttpRequest request,Function callback){
    if(request.status==200){
      Map data = JSON.parse(request.responseText);
      this.token = data['token'];
      this.user_id = data['user_id'];
      callback(true);
    }else{
      callback(false);
    }
  }
  
  
  bool login(String username,String password,Function callback){
    HttpRequest request = new HttpRequest();
    request.open("POST", '${API_URL}auth', true);
    String data;
    data = encodeMap({'username':username,'password':password});
    request.setRequestHeader('Content-type', 'application/x-www-form-urlencode');
    request.on.loadEnd.add((e) => loadEnd(request,callback));
    request.send(data);
  }
}
