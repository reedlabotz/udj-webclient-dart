library player_view;

import 'dart:html';

class PlayerView {
  Element _box;
  PlayerView(Element box){
    this._box = box; 
  }
  
  void set_state(String state){
    if(state == "playing"){
      this._box.query("#player-status").classes.remove('icon-pause');
      this._box.query("#player-status").classes.add('icon-play');
    }else{
      this._box.query("#player-status").classes.remove('icon-play');
      this._box.query("#player-status").classes.add('icon-pause');
    }
  }
  
  void set_current(Map current){
    String title = "";
    String artist = "";
    String album = "";
    
    if(current.containsKey('song')){
      title = current['song']['title'];
      artist  = current['song']['artist'];
      album = current['song']['album'];
    }
    this._box.query('#current-song-title').text = title;
    this._box.query('#current-song-artist').text = artist;
    this._box.query('#current-song-album').text = album;
  }
  
  void set_queue(List queue){
    UListElement ul = new UListElement();
    for(Map q in queue){
      LIElement li = new LIElement();
      
      ButtonElement up_vote = new ButtonElement();
      up_vote.classes.add('btn');
      Element up_vote_icon = new Element.tag("i");
      up_vote_icon.classes.add("icon-chevron-up");
      up_vote.elements.add(up_vote_icon);
      up_vote.dataAttributes['id'] = q['song']['id'];
      li.elements.add(up_vote);
      
      ButtonElement down_vote = new ButtonElement();
      down_vote.classes.add('btn');
      Element down_vote_icon = new Element.tag("i");
      down_vote_icon.classes.add("icon-chevron-down");
      down_vote.elements.add(down_vote_icon);
      down_vote.dataAttributes['id'] = q['song']['id'];
      li.elements.add(down_vote);
      
      DivElement div_title = new DivElement();
      div_title.text = q['song']['title'];
      li.elements.add(div_title);
      
      DivElement div_artist = new DivElement();
      div_artist.text = q['song']['artist'];
      li.elements.add(div_artist);
      
      DivElement div_album = new DivElement();
      div_album.text = q['song']['album'];
      li.elements.add(div_album);
      
      ul.elements.add(li);
    }
    this._box.query('#queue-holder').elements.clear();
    this._box.query('#queue-holder').elements.add(ul);
  }
  
}
