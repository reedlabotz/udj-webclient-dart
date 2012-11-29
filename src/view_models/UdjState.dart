part of udjlib;

/**
 * The global state object.
 */
class UdjState extends UIState {
  final ObservableValue<String> currentUsername;
  
  final ObservableValue<String> playerState;
  
  final ObservableValue<int> playerVolume;
  
  final ObservableValue<Player> currentPlayer;
  
  final ObservableValue<Player> localPlayer;
  
  final ObservableValue<QueueSong> nowPlaying;
  
  final ObservableValue<List<QueueSong>> queue;
  
  final ObservableValue<String> libraryView;
  
  final ObservableValue<String> searchQuery;
  
  final ObservableList<Song> librarySongs;
  
  final ObservableValue<bool> ready;
  
  final ObservableValue<bool> creatingPlayer;
  
  final UdjApp _udjApp;
      
  UdjState(this._udjApp): 
    super(), 
    currentUsername = new ObservableValue<String>(null),
    playerState = new ObservableValue<String>(null),
    playerVolume = new ObservableValue<int>(null),
    currentPlayer = new ObservableValue<Player>(null),
    localPlayer = new ObservableValue<Player>(null),
    nowPlaying = new ObservableValue<QueueSong>(null),
    queue = new ObservableValue<List<QueueSong>>(null),
    libraryView = new ObservableValue<String>(null),
    searchQuery = new ObservableValue<String>(null),
    librarySongs = new ObservableList<Song>(null),
    ready = new ObservableValue<bool>(false),
    creatingPlayer = new ObservableValue<bool>(false);
  
  void voteSong(String action,String songId){
    _udjApp.service.voteSong(action,_udjApp.state.currentPlayer.value.id,songId,(res){
      
    });
  }
  
  void addSong(String songId){
    _udjApp.service.addSong(_udjApp.state.currentPlayer.value.id,songId,(res){
      
    });
  }
}
