part of udjlib;

/**
 * Class that begins the whole app. This will be passed around 
 * to most objects, so it has access to some globals [state] and 
 * [service] that will be access by many different parts.
 */
class UdjApp extends App{
  /// The global state object
  UdjState state;
  
  /// the global service object
  UdjService service;
  
  /// Track if the page has loaded
  bool onLoadFired;
  
  /// The main view
  MainView _mainView;
  
  UdjApp(): 
    super(), 
    onLoadFired = false{
    state = new UdjState(this);
    service = new UdjService(_loginNeeded);
    setupApp();
  }
  
  void setupApp(){
    if (onLoadFired && state != null) {
      render();
      eraseSplashScreen();
    }
  }
  
  void onLoad() {
    onLoadFired = true;
    super.onLoad();
    setupApp();
  }

  
  void render(){
    _mainView = new MainView(this);
    _mainView.addToDocument(document.body);
  }
  
  /**
   * Callback fired by [service] when a re-auth is needed.
   * By setting the [state.currentUsername] to null, we will cause
   * the login screen to be displayed.
   */
  void _loginNeeded(){
    state.currentUsername.value = null;
  }
}
