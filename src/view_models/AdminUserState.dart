part of udjlib;

// AdminUserState
// ============================================================================

class AdminUserState extends UIState {
  UdjApp _udjApp;
    
  // Constructors
  // --------------------------------------------------------------------------
  
  AdminUserState(this._udjApp):super();
  
  // Methods - Content Generation
  // --------------------------------------------------------------------------
  
  /**
   * Get a list of users for the current player and run the [callback] with
   * them as the input param.
   * 
   * An empty list indicates that no users are in the player.
   * A null value indicates that an error occurred and the users are unkown.
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
  
  // Methods
  // --------------------------------------------------------------------------
  
  /**
   * Kicks a user with the given id.
   */
  void kickUser(String userID, Function callback) {
    _udjApp.service.kickUser(_udjApp.state.currentPlayer.value.id, userID, (Map status) {
      if (status['success'] || status['error'] == Errors.USER_NOT_IN_PLAYER) {
        callback(); // change to watcher
      } else {
        // notify user of errors?
        // do nothing, fail silently
      }
    });
  }
  
}
