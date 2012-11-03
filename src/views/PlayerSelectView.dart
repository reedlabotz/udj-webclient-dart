part of udjlib;

class PlayerSelectView extends CompositeView {
  final UdjApp _udjApp;  
  final PlayerSelectState _state;
  
  View _playerSelectHeader;
  PlayerSelectListView _playersList;
  View _errorMessage;
  
  // constructors
  
  /**
   * The constructor to build the player selector.
   */
  PlayerSelectView(this._udjApp, this._state):super('player-select'){
    addClass('container');
    
    // create player select box
    _playerSelectHeader = new View.html('''
        <div class="row">
          <div class="span6 offset3">
            <button type="button" class="close" aria-hidden="true">&times;</button>
            <h3>Select Player</h3>
          </div>
        </div>
    ''');
    addChild(_playerSelectHeader);
    
    _errorMessage = new View.html('''
    <div class="alert alert-error"></div>
    ''');
    _errorMessage.hidden = true;
    addChild(_errorMessage);
    
    _playersList = new PlayerSelectListView(_udjApp, _state);
    addChild(_playersList);
    
    // TODO: hide exit button if no player is selected
    
    watch(_state.hidden, _displayPlayers);
    watch(_state.players, _updatePlayers);
    watch(_state.errorMessage, _displayErrorMsg);
  }
  
  // drawing
  


  // watchers
  
  /**
   * Hide or show the player.
   */
  void _displayPlayers(e) {
    if (_state.hidden.value == true) { // hide
      hidden = true;
    } else { // show
      _state.getPlayers();
      hidden = false;
    }
  }
  
  /**
   * List the players in the [_state].
   */
  void _updatePlayers(e) {
    _playersList.rerender();
  }
  
  /**
   * Hide the error message, or update the error text and show it.
   */
  void _displayErrorMsg(e) {
    if (_state.errorMessage.value == null) {
      _errorMessage.hidden = true;
      
    } else {
      _errorMessage.node.text = _state.errorMessage.value;
      _errorMessage.hidden = false;
      
    }
  }

}

class PlayerSelectListView extends CompositeView {
  final UdjApp _udjApp;
  final PlayerSelectState _state;
  
  // constructors
  
  PlayerSelectListView(this._udjApp, this._state):super('player-select-box'){
    rerender();
  }
  
  // drawing
  
  void rerender() {
    removeAllChildren();
    
    if (_state.players.value != null) {
      for (Player p in _state.players.value) {
        View player = new View.html('''
        <div class="player">
          <div class="player-name">${p.name}</div>
          <div class="player-owner">${p.owner.username}</div>
          <div class="player-attrs">
            <span class="player-name">${p.numActiveUsers}</span>
            <span class="player-curUsers">${p.numActiveUsers}</span>
            <span class="player-maxUsers">${p.sizeLimit}</span>
          </div>
          <button class="player-join" data-player-id="${p.id}">Join</button>
        </div>
        ''');
        addChild(player);
        
        View button = new View.fromNode( player.node.query(".player-join") );
        button.addOnClick(_joinPlayer);
      } 
    }
    
  }
  
  /**
   * Add listeners after render is done.
   */
  void afterRender(Element node){
    // TODO: move the button onClick event registration here
  }
  
  // events
  
  void _joinPlayer(Event e) {
    // find the right element
    Element target = e.target;
    while (target.tagName != "BUTTON") {
      target = target.parent;
    }
    
    String playerID = target.dataAttributes['player-id'];
    _udjApp.service.auth_put_request('/players/$playerID/users/user', {}, (HttpRequest req) {
      // 201 is success, 400 is you own it
      if (req.status == 201 || req.status == 400) {
        for (Player p in _state.players.value) {
          if (p.id == playerID) {
            _udjApp.state.currentPlayer.value = p;
          }
        }
        
      } else {
        // TODO: test errors
        
        if (req.status == 403 && req.getResponseHeader('X-Udj-Forbidden-Reason') == "player-full") {
          _state.errorMessage.value = "The server is full.";
          
        } else if (req.status == 403 && req.getResponseHeader('X-Udj-Forbidden-Reason') == "banned") {
          _state.errorMessage.value = "You have been banned from this server.";
          // TODO: reload the players list from the server- filter should be applied
          
        } else {
          _state.errorMessage.value = "There was an error joining the server.";
        
        }
      }
    });
  }
  
}
