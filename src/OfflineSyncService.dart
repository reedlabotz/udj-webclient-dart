part of udjlib;

/**
 * Service that will keep important information synced offline.
 * We extend [View] so that we get the watch functionality.
 */
class OfflineSyncService extends View{
  UdjApp _udjApp;
  
  UdjService _service;
  
  // async bools
  final ObservableValue<bool> _joinPlayerComplete;
  
  OfflineSyncService(this._udjApp,this._service):
  _joinPlayerComplete = new ObservableValue<bool>(false)
  {
    _loadFromStorage();
    watch(_service.session,_saveSession);
    watch(_udjApp.state.currentPlayer,_saveCurrentPlayer);
    
    // watch async bools to test for completeness
    watch(_joinPlayerComplete, _checkLoadComplete);
  }
  
  void _loadFromStorage(){
    // must come first, so other functions that require a user to be logged in
    // will have the necessary session info
    if(window.localStorage.containsKey('session')){
      print(JSON.parse(window.localStorage['session']));
      _service.session.value = new Session.fromJson(JSON.parse(window.localStorage['session']));
      _udjApp.state.currentUsername.value = _service.session.value.username;
    }

    // must come before player-related actions, so functions that requre a
    // player will have the necessary player info
    if(window.localStorage.containsKey('player')){
      Map playerData = JSON.parse(window.localStorage['player']);
      _service.joinPlayer(playerData['id'], (Map status) {
        if (status['success'] == true) {
          _udjApp.state.currentPlayer.value = new Player.fromJson(playerData);
          print("joined: $playerData");
        
        } else {
          _udjApp.state.currentPlayer.value = null;
          
        }
        
        _joinPlayerComplete.value = true;
      });
      
    } else {
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
  
  void _saveSession(e){
    if(_service.session.value == null){
      window.localStorage.remove('session');
    }else{
      window.localStorage['session'] = JSON.stringify(_service.session.value);
    }
  }
  
  void _saveCurrentPlayer(EventSummary e){
    print(e.events.toString());
    if(_udjApp.state.currentPlayer.value == null){
      print("1");
      window.localStorage.remove('player'); 
    }else{
      print("test");
      print(JSON.stringify(_udjApp.state.currentPlayer.value));
      window.localStorage['player'] = JSON.stringify(_udjApp.state.currentPlayer.value);
    }
  }
  
  
}
