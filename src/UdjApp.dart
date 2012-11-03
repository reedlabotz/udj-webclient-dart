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
  bool constructorFired;
  
  /// The main view
  MainView _mainView;
  
  /// Service that keeps ofline in sync
  OfflineSyncService offlineSync;
  
  UdjApp():super(), 
    onLoadFired = false,
    constructorFired = false
 {
    state = new UdjState(this);
    service = new UdjService(_loginNeeded);
    offlineSync = new OfflineSyncService(this,service);
    setupApp();
  }
  
  void setupApp(){
    if (onLoadFired && state != null) {
      render();
    }
  }
  
  void onLoad() {
    onLoadFired = true;
    super.onLoad();
    setupApp();
  }

  
  void render(){
    _mainView = new MainView(this);
    
    if (state.ready.value == true) {
      _showApp();
      
    } else {
      _mainView.watch(state.ready, (e) {
        if (state.ready.value == true) {
          _showApp();
        }
      });
      
    }
  }
  
  void _showApp() {
    _mainView.addToDocument(document.body);
    eraseSplashScreen();
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
