part of udjlib;

/**
 * Service that will keep important information synced ofline.
 * We extend [View] so that we get the watch functionality.
 */
class OfflineSyncService extends View{
  UdjApp _udjApp;
  
  UdjService _service;
  
  OfflineSyncService(this._udjApp,this._service){
    _loadFromStorage();
    watch(_service.session,_saveSession);
    watch(_udjApp.state.currentPlayer,_saveCurrentPlayer);
  }
  
  void _loadFromStorage(){
    if(window.localStorage.containsKey('player')){
      _udjApp.state.currentPlayer.value = new Player.fromJson(JSON.parse(window.localStorage['player']));
    }
    if(window.localStorage.containsKey('session')){
      print(JSON.parse(window.localStorage['session']));
      _service.session.value = new Session.fromJson(JSON.parse(window.localStorage['session']));
      _udjApp.state.currentUsername.value = _service.session.value.username;
    }
  }
  
  void _saveSession(e){
    print("save session to offline");
    if(_service.session.value == null){
      window.localStorage.remove('session');
    }else{
      window.localStorage['session'] = JSON.stringify(_service.session.value);
    }
  }
  
  void _saveCurrentPlayer(e){
    if(_udjApp.state.currentPlayer.value == null){
      window.localStorage.remove('player'); 
    }else{
      window.localStorage['player'] = JSON.stringify(_udjApp.state.currentPlayer.value);
    }
    
    
  }
  
  
}
