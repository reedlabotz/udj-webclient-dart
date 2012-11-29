part of udjlib;

// AdminUserState
// ============================================================================

class AdminUserState extends UIState {
  UdjApp _udjApp;
  
  AdminUserState(this._udjApp){
    
  }
  
  // Methods - Content Generation
  // --------------------------------------------------------------------------
  
  /**
   * Get a list of users for the current player and run the [callback] with
   * them as the input param.
   * 
   * An empty list indicates that no users are in the player.
   * A null return indicates that an error occurred and the users are unkown.
   */
  void getCurrentUsers(Function callback) {
    Player current = _udjApp.state.currentPlayer.value;
    _udjApp.service.getCurrentUsers(current.id, (Map status) {
      List<User> users;
      
      if (status['success']) {
        users = new List<User>();
        for (Map user in status['users']) {
          users.add(new User.fromJson(user));
        }
      } else {
        users = null;
      }
      
      callback(users);
    });
  }
  
}
