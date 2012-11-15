part of udjlib;

// OfflineSyncService
// ============================================================================

/**
 * Service that will keep important information synced offline.
 * We extend [View] so that we get the watch functionality.
 */
class OfflineSyncService extends View{
  UdjApp _udjApp;
  
  UdjService _service;
  
  // async bools
  final ObservableValue<bool> _joinPlayerComplete;
  
  // Constructor
  // --------------------------------------------------------------------------
  
  /**
   * The constructor that builds the OfflineSyncService.  It also performs
   * an initial load.
   */
  OfflineSyncService(this._udjApp,this._service):
  _joinPlayerComplete = new ObservableValue<bool>(false)
  {
    _loadFromStorage();
    watch(_service.session,_saveSession);
    watch(_udjApp.state.currentPlayer,_saveCurrentPlayer);
    
    // watch async bools to test for completeness
    watch(_joinPlayerComplete, _checkLoadComplete);
  }
  
  // Load
  // --------------------------------------------------------------------------
  
  /**
   * Try to load saved info, if it's still valid.
   */
  void _loadFromStorage(){
    // must come first, so other functions that require a user to be logged in
    // will have the necessary session info
    if(window.localStorage.containsKey('session')){
      _service.session.value = new Session.fromJson(JSON.parse(window.localStorage['session']));
      _udjApp.state.currentUsername.value = _service.session.value.username;
    }

    // must come before player-related actions, so functions that requre a
    // player will have the necessary player info
    if(window.localStorage.containsKey('player')){
      // TODO: check for 'has_password' and decouple calls to joinPlayer and joinProtectedPlayer
      
      Map playerData = JSON.parse(window.localStorage['player']);
      _service.joinPlayer(playerData['id'], (Map status) {
        if (status['success'] == true) {
          _udjApp.state.currentPlayer.value = new Player.fromJson(playerData);
          _joinPlayerComplete.value = true;

        } else {
          // if the player requires a password, try to join it with one
          if (status['error'] == Errors.PLAYER_PROTECTED) {
            // TODO: ask for user for player password
            String password = '';
            
            _service.joinProtectedPlayer(playerData['id'], password, (Map status) {
              if (status['success']) {
                _udjApp.state.currentPlayer.value = new Player.fromJson(playerData);
                _joinPlayerComplete.value = true;
              } else {
                _udjApp.state.currentPlayer.value = null;
                _joinPlayerComplete.value = true;
              }
              
            });
            
          } else {
            _udjApp.state.currentPlayer.value = null;
            _joinPlayerComplete.value = true;
          }
          
        }
        
      });
      
    } else {
      _udjApp.state.currentPlayer.value = null;
      _joinPlayerComplete.value = true;
      
    }
    
  }
  
  /**
   * When all loading async requests have completed, the app state is ready.
   */
  void _checkLoadComplete(e) {
    if (_joinPlayerComplete.value == true) {
      _udjApp.state.ready.value = true;
    }
  }
  
  // Save
  // --------------------------------------------------------------------------
  
  /**
   * Save the current session (user info).
   */
  void _saveSession(e){
    if(_service.session.value == null){
      window.localStorage.remove('session');
    }else{
      window.localStorage['session'] = JSON.stringify(_service.session.value);
    }
  }
  
  /**
   * Save the currently joined player.
   */
  void _saveCurrentPlayer(EventSummary e){
    if(_udjApp.state.currentPlayer.value == null){
      window.localStorage.remove('player');
      
    }else{
      window.localStorage['player'] = JSON.stringify(_udjApp.state.currentPlayer.value);
    }
  }
  
  
}
