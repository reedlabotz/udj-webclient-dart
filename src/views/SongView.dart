part of udjlib;

class SongView extends CompositeView{
  final UdjApp _udjApp;
  
  final Song _song;
  
  View _vote;
  
  SongView(this._udjApp,this._song):super('song'){
    if(_song.runtimeType.toString() == "QueueSong"){
      QueueSong song = _song;
      _vote = new View.html('''
        <div class="song-vote" data-song-id="${song.id}">
          <div class="song-vote-up"><i class="icon-chevron-up"></i></div>
          <div class="song-vote-count">
            <span class="song-vote-count-up">+${song.upvoters.length}</span>/<span class="song-vote-count-down">${song.downvoters.length}</span>
          </div>
          <div class="song-vote-down"><i class="icon-chevron-down"></i></div>
        </div>
      ''');
      addChild(_vote);
    }else{
      View add = new View.html('''
        <div class="song-add" data-song-id="${_song.id}">
          <i class="icon-plus"></i>
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
