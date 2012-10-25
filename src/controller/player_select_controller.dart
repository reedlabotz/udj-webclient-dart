#library('player_select_controller');
#import("dart:html");
#import("../view/app_view.dart");

class PlayerSelectController {
  AppView app_view;
  PlayerSelectController(AppView app_view){
    this.app_view = app_view;
  }
  
  void getLocation(Function callback){
    window.navigator.geolocation.getCurrentPosition(callback, 
        (e) => app_view.throwError("Geolocation must be enabled on your browser to use UDJ."), 
        null);
  }
}
