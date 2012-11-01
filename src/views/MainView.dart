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
    _topBar = new TopBarView(this._udjApp);
    print('hi there main view');
    this.addChild(_topBar);
  }
  
}
