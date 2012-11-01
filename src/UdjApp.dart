part of udjlib;

class UdjApp extends App{
  UdjState state;
  
  bool onLoadFired;
  
  MainView _mainView;
  
  UdjApp(): super(), onLoadFired = false{
    state = new UdjState();
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
  
}
