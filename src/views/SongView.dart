part of udjlib;

class SongView extends CompositeView{
  Song _song;
  
  SongView(this._song):super('song'){
    if(_song.runtimeType == "QueueSong"){
      QueueSong song = _song;
      View vote = new View.html('''
        <div class="song-vote">
          <div class="song-vote-up"><i class="icon-chevron-up"></i></div>
          <div class="song-vote-count">
            <span class="song-vote-count-up">+${song.upvoters.length}</span>/<span class="song-vote-count-down">${song.downvoters.length}</div>
          </div>
          <div class"song-vote-down"><i class="icon-chevron-down"></i></div>
        </song>
      ''');
      addChild(vote);
    }else{
      View add = new View.html('''
        <div class="song-add">
          <i class="icon-plus"></i>
        </div>
      ''');
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
}
