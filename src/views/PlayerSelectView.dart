part of udjlib;

class PlayerSelectView extends CompositeView {
  final UdjApp _udjApp;  
  final PlayerSelectState _state;
  
  View _playerSelectHeader;
  PlayerSelectListView _playersList;
  View _errorMessage;
  View _search;
  
  // constructors
  
  /**
   * The constructor to build the player selector.
   */
  PlayerSelectView(this._udjApp, this._state):super('player-select'){    
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
    
    _search = new View.html('''
    <form id="player-select-search" class="player-select-search">
      <div class="input-append">
        <input type="text" id="player-select-search-input" class="search-query span2" placeholder="Search">
        <button type="submit" class="btn">
          <i class="icon-search"></i>
        </button>
      </div>
    </form>
    ''');
    addChild(_search);
    
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
  
  /**
   * Add listeners after render is done.
   */
  void afterRender(Element node){
    addClass('container');
    _search.node.on.submit.add(_searchFormSubmit);
  }
  
  // events
  
  void _searchFormSubmit(Event e) {
    e.preventDefault();
    InputElement searchBox = _search.node.query("#player-select-search-input");
    _state.searchPlayer(searchBox.value);
  }

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
  
  PlayerSelectListView(this._udjApp, this._state):super('player-select-list'){
    rerender();
  }
  
  // drawing
  
  void rerender() {
    removeAllChildren();
    
    if (_state.players.value != null) {
      for (Player p in _state.players.value) {
        View player = _makePlayerSelector(p);
        addChild(player);
        
        View button = new View.fromNode( player.node.query(".player-join") );
        button.addOnClick(_joinPlayer);
      } 
    }
    
  }
  
  View _makePlayerSelector(Player p) {
    String password = "";
    if (p.hasPassword) {
      password = '''
      <span class="player-protected"><i class="icon-lock"></i></span>
      ''';
    }
    
    View player = new View.html('''
    <div class="row">
      <div class="player span6 offset3">
        <div class="player-name">${p.name}</div>
        <div class="player-owner dashed">${p.owner.username}</div>
        <button class="player-join" data-player-id="${p.id}">Join</button>
        <div class="player-attrs">
          <span class="player-curUsers">${p.numActiveUsers}</span>
          <span class="player-maxUsers">${p.sizeLimit}</span>
          $password
        </div>
      </div>
    </div>
    ''');
    
    return player;
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
    
    _state.joinPlayer( target.dataAttributes['player-id'] );

  }
  
}
