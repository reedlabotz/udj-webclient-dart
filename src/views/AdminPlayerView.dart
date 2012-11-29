part of udjlib;

class AdminPlayerView extends CompositeView {
  final UdjApp _udjApp;
  
  final AdminPlayerState _controls;
  
  View _playPause;
  View _volume;
  
  AdminPlayerView(this._udjApp,this._controls):super('playeradmin'){
    _playPause = new View.html('''
    <div class="playeradmin-playPause">
      <span class="playeradmin-play"><i class="icon-play"></i></span>
      <span class="playeradmin-pause"><i class="icon-pause"></i></span>
    </div>
    ''');
    addChild(_playPause);
    
    _volume = new View.html('''
    <div class="playeradmin-volume">
      <span id="playeradmin-volumeUp" class="playeradmin-volumeUp"><i class="icon-volume-up"></i></span>
      <span id="playeradmin-volumeDown" class="playeradmin-volumeDown"><i class="icon-volume-down"></i></span>
    </div>
    ''');
    addChild(_volume);
    
  }
  
  /**
   * Callback after the node has been rendered. Add watchers and callbacks.
   */
  void afterRender(Element node){
    // events
    _playPause.node.query("#controls-play").on.click.add((Event e) {
      _controls.play();
    });
    _playPause.node.query("#controls-pause").on.click.add((Event e) {
      _controls.pause();
    });
    
    _volume.node.query("#controls-volumeUp").on.click.add((Event e) {
      _controls.increaseVolume(1);
    });
    _volume.node.query("#controls-volumeDown").on.click.add((Event e) {
      _controls.decreaseVolume(1);
    });
    
    // watchers
    watch(_udjApp.state.playerState, (e) {
      // todo: show / hide or add / remove playeradmin-play and player-admin pause
    });
  }

}
