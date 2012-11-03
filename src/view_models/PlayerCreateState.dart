part of udjlib;

class PlayerCreateState extends UIState {
  
  final UdjApp _udjApp;
  
  PlayerCreateState(this._udjApp):super();
  
  void formSubmit(Map playerAttrs) {
    _udjApp.service.createPlayer(playerAttrs, (Map status) {
      if (status['success']) {
        Player p = new Player.fromJson( status['playerData'] );
        _udjApp.state.localPlayer.value = p;
        _udjApp.state.currentPlayer.value = p;
        _udjApp.state.creatingPlayer.value = false;
        
      } else {
        // TODO: error handling
      }
    });
  }
  
}
