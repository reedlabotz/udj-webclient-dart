library player_view;

import 'dart:html';

class PlayerView {
  Element _box;
  Function _upvote_callback;
  Function _downvote_callback;
  
  PlayerView(Element box){
    this._box = box; 
  }
  
  void register_downvote_callback(Function callback){
    this._downvote_callback = callback;
  }
  
  void register_upvote_callback(Function callback){
    this._upvote_callback = callback;
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
      
      //button holder
      DivElement button_holder = new DivElement();
      button_holder.classes.add('player-vote-button-holder');
      
      //up vote button
      ButtonElement up_vote = new ButtonElement();
      up_vote.classes.add('btn');
      Element up_vote_icon = new Element.tag("i");
      up_vote_icon.classes.add("icon-chevron-up");
      up_vote.elements.add(up_vote_icon);
      up_vote.dataAttributes['id'] = q['song']['id'];
      up_vote.on.click.add(this._upvote);
      button_holder.elements.add(up_vote);
      
      DivElement vote_count = new DivElement();
      vote_count.classes.add("song-vote-count");
      SpanElement up_vote_count = new SpanElement();
      up_vote_count.classes.add("song-upvote-count");
      up_vote_count.text = "+${q['upvoters'].length}";
      vote_count.elements.add(up_vote_count);
      SpanElement vote_divider = new SpanElement();
      vote_divider.text = "/";
      vote_count.elements.add(vote_divider);
      SpanElement down_vote_count = new SpanElement();
      down_vote_count.classes.add("song-downvote-count");
      down_vote_count.text = "-${q['downvoters'].length}";
      vote_count.elements.add(down_vote_count);
      button_holder.elements.add(vote_count);
      
      //down vote button
      ButtonElement down_vote = new ButtonElement();
      down_vote.classes.add('btn');
      Element down_vote_icon = new Element.tag("i");
      down_vote_icon.classes.add("icon-chevron-down");
      down_vote.elements.add(down_vote_icon);
      down_vote.dataAttributes['id'] = q['song']['id'];
      down_vote.on.click.add(this._downvote);
      button_holder.elements.add(down_vote);
      
      li.elements.add(button_holder);
      
      //song info holder
      DivElement song_info_holder = new DivElement();
      song_info_holder.classes.add("queue-song-info-holder");
      
      DivElement div_title = new DivElement();
      div_title.classes.add('song-title');
      div_title.text = q['song']['title'];
      song_info_holder.elements.add(div_title);
      
      DivElement div_artist = new DivElement();
      div_artist.classes.add('song-artist');
      div_artist.text = q['song']['artist'];
      song_info_holder.elements.add(div_artist);
      
      DivElement div_album = new DivElement();
      div_album.classes.add('song-album');
      div_album.text = q['song']['album'];
      song_info_holder.elements.add(div_album);
      
      li.elements.add(song_info_holder);
      
      DivElement clear_fix = new DivElement();
      clear_fix.classes.add("clearfix");
      li.elements.add(clear_fix);
      
      ul.elements.add(li);
    }
    this._box.query('#queue-holder').elements.clear();
    this._box.query('#queue-holder').elements.add(ul);
  }
  
  void _upvote(MouseEvent e){
    Element target = e.target;
    if(target.tagName != "BUTTON"){
      target = target.parent;
    }
    String id = target.dataAttributes['id'];
    this._upvote_callback(id);
  }
  
  void _downvote(MouseEvent e){
    Element target = e.target;
    if(target.tagName != "BUTTON"){
      target = target.parent;
    }
    String id = target.dataAttributes['id'];
    this._downvote_callback(id);
  }
  
}
