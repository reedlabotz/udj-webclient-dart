part of udjlib;

class PlayerSelectState extends UIState{
  final UdjApp _udjApp;
  
  final ObservableList<Player> players; 
  
  final ObservableValue<bool> loading;
  
  PlayerSelectState(this._udjApp):super(),
    loading = new ObservableValue<bool>(false),
    players = new ObservableList<Player>(null){
    
  }
    
  void getPlayers(){
    window.navigator.geolocation.getCurrentPosition(
      (Geoposition position){
        _udjApp.service.auth_get_request('/players/${position.coords.latitude}/${position.coords.longitude}',{},
          (HttpRequest request){
            List players = JSON.parse(request.responseText);
            players.clear();
            players.addAll(players);
          });
      }, 
      (e){
        print("error getting position");
      });
  }
}
