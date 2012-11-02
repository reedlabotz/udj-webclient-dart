part of udjlib;

class SideBarView extends CompositeView {
  SideBarView():super('sidebar-box'){
    View temp = new View.html('''
      <div class="player-box">
        <div class="player-name">Reed's Party</div>
        <div class="player-user-count"><i class="icon-user"></i> 17</div>
        <div class="player-queue-count"><i class="icon-music"></i> 100</div>
      </div>
    ''');
    addChild(temp);
    
    View temp2 = new View.html('''
      <div class="now-playing-box">
        <div class="now-playing-status"><i class="icon-play"></i></div>
        <div class="now-playing-song-name">Friday</div>
        <div class="now-playing-song-artist">Rebecca Black</div><div class="now-playing-song-album">Friday</div>
      </div>
    ''');
    addChild(temp2);
    
    View temp3 = new View.html('''
      <div class="queue-box">
        <div class="song-box">
          <div class="song-box-name">Friday</div>
          <div class="song-box-artist">Rebecca Black</div><div class="song-box-album">Friday</div>
        </div>
      </div>
    ''');
    addChild(temp3);
  }
}
