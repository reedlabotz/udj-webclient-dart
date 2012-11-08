part of udjlib;

// PlayerSelectState
// ============================================================================

class PlayerSelectState extends UIState{
  /// The [UdjApp] (which provides access to the [UdjState]).
  final UdjApp _udjApp;
  
  /// Variables to watch.
  final ObservableValue<List<Player>> players;
  final ObservableValue<bool> loading;
  final ObservableValue<bool> hidden;
  final ObservableValue<String> errorMessage;
  
  // Constructors
  // --------------------------------------------------------------------------
  
  /**
   * Create the [PlayerSelectState].
   */
  PlayerSelectState(this._udjApp):super(),
    players = new ObservableValue<List<Player>>(null),
    loading = new ObservableValue<bool>(false),
    hidden = new ObservableValue<bool>(true),
    errorMessage = new ObservableValue<String>(null);
  
  // Methods
  // --------------------------------------------------------------------------
  
  /**
   * Get the players by geolocation.
   */
  void getPlayers(){
    errorMessage.value = null;
    
    window.navigator.geolocation.getCurrentPosition(
      (Geoposition position){
        _udjApp.service.getPlayersByPosition(position, function(Map status) {
          if (status['success']) {
            players.value = _buildPlayers(status['playerData']);
          }
          // TODO: handle errors w/ else
        });
      }, 
      (e){
        print("error getting position");
      });
  }

  /**
   * Get the player by searching (for its name).
   */
  void searchPlayer(String search) {
    _udjApp.service.getSearchPlayer(search, function(Map status) {
      if (status['success']) {
        players.value = _buildPlayers(status['players']);
      }
      // TODO: handle errors w/ else
    });
  }
  
  /**
   * Build a list of players from json.
   */
  List<Player> _buildPlayers(List playersData) {
    List<Player> players = new List<Player>();
    for (var data in playersData) {
      players.add(new Player.fromJson(data));
    }
    
    return players;
  }
  
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
  
}
