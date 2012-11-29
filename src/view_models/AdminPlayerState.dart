part of udjlib;

// AdminPlayerState
// ============================================================================

class AdminPlayerState extends UIState {
  UdjApp _udjApp;

  // Constructors
  // --------------------------------------------------------------------------
  
  AdminPlayerState(this._udjApp):super();

  // Methods - Event Handlers
  // --------------------------------------------------------------------------
  
  /**
   * Play the current player.
   */
  void play() {
    if (_udjApp.state.canAdmin() && _udjApp.state.playerState.value != "Playing") {
      _udjApp.service.setPlayerState(_udjApp.state.currentPlayer.value.id, 'play', (Map status) {
        if (status['success']) {
          // TODO: refactor to a constant
          _udjApp.state.playerState.value = "Playing"; // see sidebar view for value / similar functionality
        } else {
          // notify user of errors?
          // do nothing, fail silently
        }
        
      });
      
    } else {
      // error msg?
    }
  }
  
  /**
   * Pause the current player.
   */
  void pause() {
    if (_udjApp.state.canAdmin() && _udjApp.state.playerState != "Paused") {
      _udjApp.service.setPlayerState(_udjApp.state.currentPlayer.value.id, 'pause', (Map status) {
        if (status['success']) {
          // TODO: refactor to a constant
          _udjApp.state.playerState.value = "Paused"; // see sidebar view for value / similar functionality
        } else {
          // notify user of errors?
          // do nothing, fail silently
        }
        
      });
      
    } else {
      // error msg?
    }
  }
  
  /**
   * Change the volume for the current player by an [amount].
   */
  void changeVolume(int amount) {
    if (_udjApp.state.canAdmin()) {
      int newVolume = _udjApp.state.playerVolume.value + amount;
      _udjApp.service.setPlayerVolume(_udjApp.state.currentPlayer.value.id, newVolume, (Map status) {
        if (status['success']) {
          _udjApp.state.playerVolume.value = newVolume;
        } else {
          // notify user of errors?
          // do nothing, fail silently
        }
      });

    } else {
      // error msg?
    }
  }
  
}