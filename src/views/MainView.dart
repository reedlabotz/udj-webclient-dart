part of udjlib;
/*
 * Main view of the udj app. This view will initialize all child views.
 */
class MainView extends CompositeView{
  /// Reference to the udj app.
  final UdjApp _udjApp;
  
  /// The top bar which holds the library view select and search.
  TopBarView _topBar;
  
  /// The side bar which holds current player info box, now playing box, and queue
  SideBarView _sideBar;
  
  /// The library view to hold the library
  LibraryView _library;
  
  /// The login view which is shown at login and in case of reauth.
  LoginView _login;
  
  /// The player select view-model.
  PlayerSelectState _playerSelectState;
  
  /// The player select view that is shown if no player is selected.
  PlayerSelectView _playerSelect;
  
  /*
   * Initialize the view and create all the child views.
   */
  MainView(this._udjApp):super('all-hold'){
    // Create the top bar
    _topBar = new TopBarView(_udjApp);
    addChild(_topBar);
    
    // Create the login view
    LoginState loginState = new LoginState(_udjApp);
    _login = new LoginView(_udjApp, loginState);
    addChild(_login);
    
    // Create the player select view
    _playerSelectState = new PlayerSelectState(this._udjApp);
    _playerSelect = new PlayerSelectView(_udjApp, _playerSelectState);
    addChild(_playerSelect);
    
    // Create the side bar view
    _sideBar = new SideBarView(this._udjApp);
    addChild(_sideBar);
    
    // Create the library view
    _library = new LibraryView();
    addChild(_library);
    
    // Call [_swapLoggedInView] to get initial view setup correctly
    _chooseView();
  }
  
  /**
   * After render add listeners.
   */
  void afterRender(Element node){
    watch(_udjApp.state.currentUsername, (e) => _chooseView());
    watch(_udjApp.state.currentPlayer, (e) => _chooseView());
  }
  
  /**
   * Chooses the view to show the user based on the udjApp state.
   */
  void _chooseView(){
    // login
    if (_udjApp.state.currentUsername.value == null) {
      _topBar.hidden = true;
      _sideBar.hidden = true;
      _library.hidden = true;
      _playerSelectState.hidden.value = true;

      _login.hidden = false;
    }
    
    // choose a player
    else if (_udjApp.state.currentPlayer.value == null) {
      _topBar.hidden = true;
      _sideBar.hidden = true;
      _library.hidden = true;
      _login.hidden = true;
      
      _playerSelectState.hidden.value = false;
    }
    
    // use udj
    else {
      _login.hidden = true;
      _playerSelectState.hidden.value = true;
      
      _topBar.hidden = false;
      _sideBar.hidden = false;
      _library.hidden = false;

    }
  }
}
