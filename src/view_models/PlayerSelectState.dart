part of udjlib;

class PlayerSelectState extends UIState{
  final UdjApp _udjApp;
  
  final ObservableValue<List<Player>> players; 
  
  final ObservableValue<bool> loading;
  
  final ObservableValue<bool> hidden;
  
  // constructors
  
  PlayerSelectState(this._udjApp):super(),
    players = new ObservableValue<List<Player>>(null),
    loading = new ObservableValue<bool>(false),
    hidden = new ObservableValue<bool>(true);
    
  // getters / setters
    
  void getPlayers(){
    window.navigator.geolocation.getCurrentPosition(
      (Geoposition position){
        _udjApp.service.auth_get_request('/players/${position.coords.latitude}/${position.coords.longitude}',{},
          (HttpRequest request){
            List playerData = JSON.parse(request.responseText);
            List<Player> playersTmp = new List<Player>();
            for (var data in playerData) {
              playersTmp.add(new Player.fromJson(data));
            }
            
            players.value = playersTmp;
        });
      }, 
      (e){
        print("error getting position");
      });
  }
}
