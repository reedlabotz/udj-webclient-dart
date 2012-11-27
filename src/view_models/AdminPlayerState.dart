part of udjlib;

class AdminPlayerState extends UIState {
  UdjApp _udjApp;
  
  AdminPlayerState(this._udjApp){
    
  }
  
  // event handlers
  
  void play() {
    if (_canAdmin()) {
      // try to play the song
      
    } else {
      // error msg
      
    }
  }
  
  void pause() {
    if (_canAdmin()) {
      // try to pause the song
      
    } else {
      // error msg
      
    }
  }
  
  void increaseVolume(int amount) {
    if (_canAdmin()) {
      
      // try to turn the volume up by amount
      //  - requires previous amount
    } else {
      // error msg
      
    }
  }
  
  void decreaseVolume(int amount) {
    if (_canAdmin()) {
  
      // try to turn the volume down by amount
      //  - requires previous amount
    } else {
      // error msg
      
    }
    
  }
  
  /**
   * Make sure the user is in a player and is an admin of that player.
   */
  bool _canAdmin() {
    Player p = _udjApp.state.currentPlayer.value;
    String name = _udjApp.state.currentUsername.value;
    
    bool inPlayer = p != null;
    bool isAdmin = p.admins.some((User admin) {
      return admin.username == name;
    });
    
    return inPlayer && isAdmin;
  }
  
}