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
  CompositeView _sideBar;
  
  /// The login view which is shown at login and in case of reauth.
  CompositeView _login;
  
  /// The player select view which shows on first load and when the user chooses to change players.
  CompositeView _playerSelect;
  
  /*
   * Initialize the view and create all the child views.
   */
  MainView(this._udjApp):super('all-hold'){
    _topBar = new TopBarView(_udjApp);
    this.addChild(_topBar);
    
    LoginState loginState = new LoginState(this._udjApp);
    _login = new LoginView(_udjApp, loginState);
    this.addChild(_login);
    
    _swapLoggedInView();
  }
  
  /**
   * After render add listeners.
   */
  void afterRender(Element node){
    watch(_udjApp.state.currentUsername, (e) => _swapLoggedInView());
  }
  
  /**
   * Swap the the views to show login or logged in view.
   */
  void _swapLoggedInView(){
    if(_udjApp.state.currentUsername.value != null){
      _topBar.hidden = false;
      _login.hidden = true;
    }else{
      _topBar.hidden = true;
      _login.hidden = false;
    }
  }
  
}
