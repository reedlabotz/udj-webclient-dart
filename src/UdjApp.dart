part of udjlib;

class UdjApp extends App{
  UdjState state;
  
  bool onLoadFired;
  
  MainView _mainView;
  
  UdjApp(): super(), onLoadFired = false{
    state = new UdjState();
    setupApp();
  }
  
  void setupApp(){
    if (onLoadFired && state != null) {
      render();
      eraseSplashScreen();
    }
  }
  
  void onLoad() {
    onLoadFired = true;
    super.onLoad();
    setupApp();
  }

  
  void render(){
    _mainView = new MainView(this);
    _mainView.addToDocument(document.body);
  }
  
  void login(String username, String password){
    HttpRequest request = new HttpRequest();
    request.open("POST", '${Constants.API_URL}/auth', true);
    String data;
    data = RequestHelper.encodeMap({'username':username,'password':password});
    request.setRequestHeader('Content-type', 'application/x-www-form-urlencode');
    request.on.loadEnd.add((e){
      print("hi");
      print(request);
      if(request.status==200){
        print("success");
        var data = JSON.parse(request.responseText);
        var token = data['ticket_hash'];
        var user_id = data['user_id'];
        state.session.value = new Session(token, user_id, username);
        state.loggedIn.value = true;
        print(state.loggedIn.value);
      }else{
        
      }
    });
    request.send(data);
  }
}
