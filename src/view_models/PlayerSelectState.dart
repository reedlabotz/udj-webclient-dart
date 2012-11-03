part of udjlib;

class PlayerSelectState extends UIState{
  final UdjApp _udjApp;
  
  final ObservableValue<List<Player>> players; 
  
  final ObservableValue<bool> loading;
  
  final ObservableValue<bool> hidden;
  
  final ObservableValue<String> errorMessage;
  
  // constructors
  
  PlayerSelectState(this._udjApp):super(),
    players = new ObservableValue<List<Player>>(null),
    loading = new ObservableValue<bool>(false),
    hidden = new ObservableValue<bool>(true),
    errorMessage = new ObservableValue<String>(null);
    
  // getters / setters
    
  void getPlayers(){
    errorMessage.value = null;
    
    window.navigator.geolocation.getCurrentPosition(
      (Geoposition position){
        _udjApp.service.auth_get_request('/players/${position.coords.latitude}/${position.coords.longitude}',{},
          (HttpRequest request){
            List playerData = JSON.parse(request.responseText);
            List<Player> playersTmp = new List<Player>();
            for (var data in playerData) {
              playersTmp.add(new Player.fromJson(data));
            }
            
            players.value = playersTmp;
        });
      }, 
      (e){
        print("error getting position");
      });
  }
  
  /**
   * Attempt to join a player.
   */
  void joinPlayer(String playerID) {
    _udjApp.service.auth_put_request('/players/$playerID/users/user', {}, (HttpRequest req) {
      // 201 is success, 400 is you own it
      if (req.status == 201 || req.status == 400) {
        for (Player p in players.value) {
          if (p.id == playerID) {
            _udjApp.state.currentPlayer.value = p;
          }
        }
        
      } else {
        // TODO: test errors
        
        if (req.status == 403 && req.getResponseHeader('X-Udj-Forbidden-Reason') == "player-full") {
          errorMessage.value = "The server is full.";
          
        } else if (req.status == 403 && req.getResponseHeader('X-Udj-Forbidden-Reason') == "banned") {
          errorMessage.value = "You have been banned from this server.";
          // TODO: reload the players list from the server- filter should be applied
          
        } else {
          errorMessage.value = "There was an error joining the server.";
        
        }
      }
    });
  }
  
}
