part of udjlib;

class SideBarView extends CompositeView {
  final UdjApp _udjApp;
  
  final SideBarState _state;
  
  /// Information about the player a user is currently in.
  View _playerInfo;
  
  QueueView _queueView;
  
  // constructors
  
  SideBarView(this._udjApp,this._state):super('sidebar-box'){
    _playerInfo = new View.html('''
      <div class="player-box">
        <div class="player-name"></div>
        <div class="player-user-count"><i class="icon-user"></i></div>
        <div class="player-queue-count"><i class="icon-music"></i></div>
      </div>
    ''');
    addChild(_playerInfo);
    
    
    View temp2 = new View.html('''
      <div class="now-playing-box">
        <div class="now-playing-status"><i class="icon-play"></i></div>
        <div class="now-playing-song-name">Friday</div>
        <div class="now-playing-song-artist">Rebecca Black</div><div class="now-playing-song-album">Friday</div>
      </div>
    ''');
    addChild(temp2);
    
    _queueView = new QueueView(_udjApp,_state);
    addChild(_queueView);
  }
  
  void afterRender(Element node){
    // player info watching
    watch(_udjApp.state.currentPlayer, _changeCurrentPlayer);
    watch(_udjApp.state.queue,(e) => _queueView.rerender());
  }
  
  // watchers
  
  /**
   * Update the player the user is currently in.
   */
  _changeCurrentPlayer(e) {
    Player p = _udjApp.state.currentPlayer.value;
    if (p != null) {
      _playerInfo.node.query(".player-name").text = p.name;
      _playerInfo.node.query(".player-user-count").text = p.numActiveUsers.toString();
      _updateQueueCount();
      
    } else {
      _playerInfo.node.query(".player-name").text = "";
      _playerInfo.node.query(".player-user-count").text = "";
      _playerInfo.node.query(".player-queue-count").text = "";
      
    }
  }
  
  /**
   * Updates the number of songs in the queue.
   */
  _updateQueueCount() {
    List<QueueSong> queue = _udjApp.state.queue.value;
    if (queue != null && _udjApp.state.currentPlayer.value != null) {
      _playerInfo.node.query(".player-queue-count").text = queue.length.toString();
      
    } else {
      _playerInfo.node.query(".player-queue-count").text = "--";
      
    }
  }
  
}

class QueueView extends CompositeView{
  final UdjApp _udjApp;
  
  final SideBarState _state;
  
  QueueView(this._udjApp,this._state):super('queue-box'){
    rerender();
  }
  
  void rerender(){
    removeAllChildren();
    if(_udjApp.state.queue.value != null){
      for(var s in _udjApp.state.queue.value){
        View song = new SongView(_udjApp,s);
        addChild(song);
      }
    }
    
  }
}
