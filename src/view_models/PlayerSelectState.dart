part of udjlib;

class PlayerSelectState extends UIState{
  final UdjApp _udjApp;
  
  final ObservableList<Player> players; 
  
  final ObservableValue<bool> loading;
  
  PlayerSelectState(this._udjApp):super(),
    loading = new ObservableValue<bool>(false),
    players = new ObservableList<Player>(null){
    
  }
}
