part of udjlib;

class AdminPlayerState extends UIState {
  UdjApp _udjApp;
  
  AdminPlayerState(this._udjApp){
    
  }
  
  // event handlers
  
  void play() {
    if (canAdmin() && _udjApp.state.playerState.value != "Playing") {
      _udjApp.service.setPlayerState(_udjApp.state.currentPlayer.value.id, 'play', (Map status) {
        if (status['success']) {
          // TODO: refactor to a constant
          _udjApp.state.playerState.value = "Playing"; // see sidebar view for value / similar functionality
          
        } else {
          // handle errors
          // notify user of errors
        }
        
      });
      
    } else {
      // error msg- is not an admin
      
    }
  }
  
  void pause() {
    if (canAdmin() && _udjApp.state.playerState != "Paused") {
      _udjApp.service.setPlayerState(_udjApp.state.currentPlayer.value.id, 'pause', (Map status) {
        if (status['success']) {
          // TODO: refactor to a constant
          _udjApp.state.playerState.value = "Paused"; // see sidebar view for value / similar functionality

        } else {
          // handle errors
          // notify user of errors
        }
        
      });
      
    } else {
      // error msg
      
    }
  }
  
  void changeVolume(int amount) {
    if (canAdmin()) {
      int newVolume = _udjApp.state.playerVolume.value + amount;
      _udjApp.service.setPlayerVolume(_udjApp.state.currentPlayer.value.id, newVolume, (Map status) {
        if (status['success']) {
          _udjApp.state.playerVolume.value = newVolume;
        }
      });

    } else {
      // error msg
      
    }
  }
  
  /**
   * Make sure the user is in a player and is an admin of that player.
   */
  bool canAdmin() {
    Player p = _udjApp.state.currentPlayer.value;
    String name = _udjApp.state.currentUsername.value;
    
    bool inPlayer = p != null;
    bool isAdmin = p.admins.some((User admin) {
      return admin.username == name;
    });
    bool isOwner = p.owner.username == name;
    
    return inPlayer && (isAdmin || isOwner);
  }
  
}