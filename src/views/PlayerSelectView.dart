part of udjlib;

// PlayerSelectView
// ============================================================================

/**
 * The [PlayerSelectView] allows users to find information about players and
 * join them.  If the user is already in a player, the have the option to exit
 * the [PlayerSelectView].  Finally, the view should provide a way for the user
 * to access the [PlayerCreateView].
 */
class PlayerSelectView extends CompositeView {
  /// The [UdjApp] (which provides access to the [UdjState]).
  final UdjApp _udjApp;

  /// Other states this view can access.
  final PlayerSelectState _state;
  
  /// The currently joined player (when changing players).
  Player _prevPlayer;
  
  /// Display the view's title and an exit button. 
  View _playerSelectHeader;
  
  /// A collection of view UI utilities, including search, error messages, and create player button.
  CompositeView _actionbar;
  View _search;
  View _errorMessage;
  View _createPlayer;

  /// A list of players.
  PlayerSelectListView _playersList;
    
  // Constructors
  // --------------------------------------------------------------------------
  
  /**
   * The constructor to build the player selector.
   */
  PlayerSelectView(this._udjApp, this._state):super('player-select'){
    _prevPlayer = null;
    
    // header
    _playerSelectHeader = new View.html('''
        <div class="row">
          <div class="span6 offset3">
            <button type="button" id="player-select-close" class="close" aria-hidden="true">&times;</button>
            <h3>Select Player</h3>
          </div>
        </div>
    ''');
    addChild(_playerSelectHeader);
    // TODO: hide exit button if no player is selected
    
    // action bar
    CompositeView actionbarWrap = new CompositeView('row');
    _actionbar = new CompositeView('player-select-actionbar');
    actionbarWrap.addChild(_actionbar);
    
    _createPlayer = new View.html('''
    <button type="button" id="player-select-create">Create</button>
    ''');
    _actionbar.addChild(_createPlayer);
    
    _search = new View.html('''
    <form id="player-select-search" class="player-select-search form-search">
      <div class="input-append">
        <input type="text" id="player-select-search-input" class="search-query span2" placeholder="Search">
        <button type="submit" class="btn">
          <i class="icon-search"></i>
        </button>
      </div>
    </form>
    ''');
    _actionbar.addChild(_search);
        
    _errorMessage = new View.html('''
    <div class="alert alert-error"></div>
    ''');
    _errorMessage.hidden = true;
    _actionbar.addChild(_errorMessage);
    _actionbar.addChild(new View.html('<div class="clearfix"></div>'));
    
    addChild(actionbarWrap);
    
    // players list
    CompositeView playersListWrap = new CompositeView('row');
    CompositeView playersListSpan = new CompositeView('span6 offset3');
    playersListWrap.addChild(playersListSpan);
    
    _playersList = new PlayerSelectListView(_udjApp, _state);
    playersListSpan.addChild(_playersList);
    
    addChild(playersListWrap);
  }
  
  /**
   * Add listeners after render is done.
   */
  void afterRender(Element node){
    addClass('container');
    _actionbar.addClass('span6');
    _actionbar.addClass('offset3');
    
    // watching
    watch(_state.hidden, _displayPlayers);
    watch(_state.players, _updatePlayers);
    watch(_state.errorMessage, _displayErrorMsg);
    watch(_udjApp.state.currentPlayer, _changePlayer);
    
    // events
    _search.node.on.submit.add(_searchFormSubmit);
    
    _playerSelectHeader.node.query("#player-select-close").on.click.add((Event e) {
      if (_prevPlayer != null) {
        _udjApp.state.currentPlayer.value = _prevPlayer;
        _state.hidden.value = true;
      }
      // TODO: handle else?  x should be hidden if no prev player
    });
    
    _createPlayer.node.on.click.add((Event e) {
      _udjApp.state.creatingPlayer.value = true;
    });
    
  }
  
  // Event Handlers & Watchers
  // --------------------------------------------------------------------------
  
  /**
   * Search for a player.
   */
  void _searchFormSubmit(Event e) {
    e.preventDefault();
    InputElement searchBox = _search.node.query("#player-select-search-input");
    _state.searchPlayer(searchBox.value);
  }
  
  /**
   * Hide or show the [PlayerSelectView].
   */
  void _displayPlayers(e) {
    if (_prevPlayer == null) {
      _playerSelectHeader.node.query("#player-select-close").style.display = "none";
    } else {
      _playerSelectHeader.node.query("#player-select-close").style.display = "";
    }
    
    if (_state.hidden.value == true) { // hide
      hidden = true;
    } else { // show
      _state.getPlayers();
      hidden = false;
    }
  }
  
  /**
   * Show the [PlayerSelectView] to allow the user to change a player.
   */
  void _changePlayer(EventSummary e) {
    if (e.events.isEmpty == false) {
      _prevPlayer = e.events[0].oldValue;
      
      // TODO: check if current player is null rather than assuming it isn't?
      _state.hidden.value = false;
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


// PlayerSelectListView
// ============================================================================

/**
 * The [PlayerSelectListView] provides a list of [Player]s the user can try to
 * join.
 */
class PlayerSelectListView extends CompositeView {
  final UdjApp _udjApp;
  final PlayerSelectState _state;
  
  // Constructors
  // --------------------------------------------------------------------------
  
  /**
   * Build the list of [Player]s.
   */
  PlayerSelectListView(this._udjApp, this._state):super('player-select-list'){
    rerender();
  }
  
  /**
   * Add listeners after render is done.
   */
  void afterRender(Element node){
    // TODO: move the button onClick event registration here
    addClass('well');
  }
  
  // Drawing
  // --------------------------------------------------------------------------
  
  /**
   * Build the list of [Player]s.
   */
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
  
  /**
   * Add an individual [Player]'s display into the list.
   */
  View _makePlayerSelector(Player p) {
    String password = '<span class="player-attr"></span>';
    if (p.hasPassword) {
      password = '''
      <span class="player-attr"><i class="icon-lock"></i></span>
      ''';
    }
    
    View player = new View.html('''
    <div class="player">
      <div class="player-name">${p.name}</div>
      <div class="player-owner dashed">${p.owner.username}</div>
      <button class="player-join" data-player-id="${p.id}">Join</button>
      <div class="player-attrs">
        <span class="player-attr"><i class="icon-user"></i>${p.numActiveUsers}</span>
        <span class="player-attr"><i class="icon-music"></i>${p.sizeLimit}</span>
        $password
      </div>

      <div class="clearfix"></div>
    </div>
    ''');
    
    return player;
  }
  
  // Events & Watchers
  // --------------------------------------------------------------------------
  
  /**
   * Tell the [PlayerSelectState] when the user joings a player.
   */
  void _joinPlayer(Event e) {
    // find the right element
    Element target = e.target;
    while (target.tagName != "BUTTON") {
      target = target.parent;
    }
    
    _state.joinPlayer( target.dataAttributes['player-id'] );

  }
  
}
