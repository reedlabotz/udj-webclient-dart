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
        _udjApp.service.authGetRequest('/players/${position.coords.latitude}/${position.coords.longitude}',{},
          (HttpRequest request){
            List playerData = JSON.parse(request.responseText);
            players.value = _buildPlayers(playerData);
            
        });
      }, 
      (e){
        print("error getting position");
      });
  }
  
  // methods
  
  /**
   * Attempt to join a player.
   */
  void joinPlayer(String playerID) {
    _udjApp.service.joinPlayer(playerID, (Map status) {
      if (status['success'] == true) {
        for (Player p in players.value) {
          if (p.id == playerID) {
            _udjApp.state.currentPlayer.value = p;
          }
        }
        
      } else {
        // TODO: test errors - currently the server responds correctly but the browser gives an error:
        // Refused to get unsafe header "X-Udj-Forbidden-Reason"
        var error = status['error'];
        
        if (error == Errors.PLAYER_FULL) {
          errorMessage.value = "The server is full.";
          
        } else if (error == Errors.PLAYER_BANNED) {
          errorMessage.value = "You have been banned from this server.";
          // TODO: reload the players list from the server- filter should be applied
          
        } else { // error == Errors.UNKOWN
          errorMessage.value = "There was an error joining the server.";
        
        }
      }
    });
  }
  
  void searchPlayer(String search) {
    _udjApp.service.getSearchPlayer(search, _searchPlayerComplete);
  }
  
  void _searchPlayerComplete(Map status) {
    if (status['success']) {
      players.value = _buildPlayers(status['players']);
    
    }
  }
  
  List<Player> _buildPlayers(List playersData) {
    List<Player> players = new List<Player>();
    for (var data in playersData) {
      players.add(new Player.fromJson(data));
    }
    
    return players;
  }
  
}
