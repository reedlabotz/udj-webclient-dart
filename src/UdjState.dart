
class UdjState extends UIState {
  final ObservableValue<bool> loggedIn;
  
  final ObservableValue<String> playerState;
  
  final ObservableValue<Player> currentPlayer;
  
  final ObservableValue<QueueSong> nowPlaying;
  
  final ObservableList<QueueSong> queue;
  
  final ObservableList<Player> playerList;
  
  final ObservableValue<String> playerSection;
  
  final ObservableList<Song> librarySongs;
  
  UdjState(): 
    super(), 
    loggedIn = new ObservableValue<bool>(false),
    playerState = new ObservableValue<String>(null),
    currentPlayer = new ObservableValue<Player>(null),
    nowPlaying = new ObservableValue<QueueSong>(null),
    queue = new ObservableList<QueueSong>(null),
    playerList = new ObservableList<Player>(null),
    playerSection = new ObservableValue<String>(null),
    librarySongs = new ObservableList<Song>(null){
      
    }
}
