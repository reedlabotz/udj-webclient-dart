part of udjlib;

// SongView
// ============================================================================

class SongView extends CompositeView{
  final UdjApp _udjApp;
  
  final Song _song;
  
  View _vote;
  
  // Constructors
  // --------------------------------------------------------------------------
  
  // TODO: refactor QueueSong parts out, so that a QueueSong contains an inner Song view
  SongView(this._udjApp,this._song):super('song'){
    if(_song.runtimeType.toString() == "QueueSong"){
      QueueSong song = _song;
      
      _vote = new View.html('''
        <div class="song-vote" data-song-id="${song.id}">
          <div class="song-vote-up"><button><i class="icon-chevron-up"></i></button></div>
          <div class="song-vote-count">
            <span class="song-vote-count-up">+${song.upvoters.length}</span>/<span class="song-vote-count-down">-${song.downvoters.length}</span>
          </div>
          <div class="song-vote-down"><button><i class="icon-chevron-down"></i></button></div>
        </div>
      ''');
      addChild(_vote);
      
      if (_udjApp.state.canAdmin()) {
        View adder = new View.html('''
          <div class="song-adder">
            <span class="song-adder-user">Added by ${song.adder.username}</span>
            <span class="song-adder-time"> at ${song.timeAdded}</span>
          </div>
        ''');
      }
      
    }else{
      View add = new View.html('''
        <div class="song-add" data-song-id="${_song.id}">
          <button><i class="icon-plus"></i></button>
        </div>
      ''');
      add.addOnClick((Event e){
        Element target = e.target;
        while(!target.classes.contains('song-add')){
          target = target.parent;
        }
        String id = target.dataAttributes['song-id'];
        _udjApp.state.addSong(id);
      });
      addChild(add);
    }
    
    View info = new View.html('''
      <div class="song-info">
        <div class="song-title">${_song.title}</div>
        <span class="song-artist">${_song.artist}</span> - <span class="song-album">${_song.album}</span>
      </div>
    ''');
    
    addChild(info);
    addChild(new View.html('<div class="clearfix"></div>'));
  }
  
  void afterRender(Element node){
    if(_song.runtimeType.toString() == "QueueSong"){
      View downvote = new View.fromNode(_vote.node.query('.song-vote-down'));
      downvote.addOnClick((Event e){
        Element target = e.target;
        while(!target.classes.contains('song-vote')){
          target = target.parent;
        }
        String id = target.dataAttributes['song-id'];
        _udjApp.state.voteSong('downvote',id);
      });
      View upvote = new View.fromNode(_vote.node.query('.song-vote-up'));
      upvote.addOnClick((Event e){
        Element target = e.target;
        while(!target.classes.contains('song-vote')){
          target = target.parent;
        }
        String id = target.dataAttributes['song-id'];
        _udjApp.state.voteSong('upvote',id);
      }); 
    }
    super.afterRender(node);
  }
}
