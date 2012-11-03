part of udjlib;

class UdjState extends UIState {
  final ObservableValue<bool> loggedIn;
  
  final ObservableValue<String> playerState;
  
  final ObservableValue<Player> currentPlayer;
  
  final ObservableValue<QueueSong> nowPlaying;
  
  final ObservableList<QueueSong> queue;
  
  final ObservableList<Player> playerList;
  
  final ObservableValue<String> libraryView;
  
  final ObservableValue<Session> session;
  
  final ObservableValue<String> searchQuery;
  
  UdjState(): 
    super(), 
    loggedIn = new ObservableValue<bool>(false),
    playerState = new ObservableValue<String>(null),
    currentPlayer = new ObservableValue<Player>(null),
    nowPlaying = new ObservableValue<QueueSong>(null),
    queue = new ObservableList<QueueSong>(null),
    playerList = new ObservableList<Player>(null),
    libraryView = new ObservableValue<String>(null),
    session = new ObservableValue<Session>(null),
    searchQuery = new ObservableValue<String>(null){
      
  }
}
