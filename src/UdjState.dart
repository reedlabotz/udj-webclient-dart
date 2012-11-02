part of udjlib;

class UdjState extends UIState {
  final ObservableValue<bool> loggedIn;
  
  final ObservableValue<String> playerState;
  
  final ObservableValue<Player> currentPlayer;
  
  final ObservableValue<QueueSong> nowPlaying;
  
  final ObservableList<QueueSong> queue;
  
  final ObservableList<Player> playerList;
  
  final ObservableValue<String> libraryView;
  
  final ObservableValue<String> searchTerm;
  
  final ObservableList<Song> librarySongs;
  
  final ObservableValue<Session> session;
  
  UdjState(): 
    super(), 
    loggedIn = new ObservableValue<bool>(false),
    playerState = new ObservableValue<String>(null),
    currentPlayer = new ObservableValue<Player>(null),
    nowPlaying = new ObservableValue<QueueSong>(null),
    queue = new ObservableList<QueueSong>(null),
    playerList = new ObservableList<Player>(null),
    libraryView = new ObservableValue<String>(null),
    searchTerm = new ObservableValue<String>(null),
    librarySongs = new ObservableList<Song>(null),
    session = new ObservableValue<Session>(null){
      
  }
}
