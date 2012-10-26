library library_view;

import 'dart:html';
import 'dart:json';

class LibraryView {
  Element _box;
  Function _add_callback;
  Function _random_btn_callback;
  Function _artists_btn_callback;
  Function _recent_btn_callback;
  Function _search_callback;
  
  LibraryView(Element box){
    this._box = box;
    this._box.query("#random-tab").on.click.add((e) => this._random_btn_callback());
    this._box.query("#artists-tab").on.click.add((e) => this._artists_btn_callback());
    this._box.query("#recent-tab").on.click.add((e) => this._recent_btn_callback());
  }
  
  void register_add_callback(Function callback){
    this._add_callback = callback;
  }
  
  void register_random_click(Function callback){
    this._random_btn_callback = callback;
  }
  
  void register_artist_click(Function callback){
    this._artists_btn_callback = callback;
  }
  
  void register_recent_click(Function callback){
    this._recent_btn_callback = callback;
  }
  
  void register_search_click(Function callback){
    this._search_callback = callback;
  }
  
  void activate_random(){
    for(var t in this._box.queryAll('.tab')){
      t.classes.remove('active');
    }
    this._box.query('#random-tab').classes.add('active');
  }
  
  void activate_recent(){
    for(var t in this._box.queryAll('.tab')){
      t.classes.remove('active');
    }
    this._box.query('#recent-tab').classes.add('active');
  }
  
  void display_song_set(List songs){
    TableElement table = new TableElement();
    table.classes.add("table");
    table.classes.add("table-striped");
    
    //create table header
    table.createTHead();
    
    TableRowElement tr_head = new TableRowElement();
    
    TableCellElement td_add = new Element.tag("th");
    td_add.text = "";
    tr_head.elements.add(td_add);
    
    TableCellElement td_title = new Element.tag("th");
    td_title.text = "Title";
    tr_head.elements.add(td_title);
    
    TableCellElement td_artist = new Element.tag("th");
    td_artist.text = "Artist";
    tr_head.elements.add(td_artist);
    
    TableCellElement td_album = new Element.tag("th");
    td_album.text = "Album";
    tr_head.elements.add(td_album);
    
    table.tHead.elements.add(tr_head);
    
    var table_body = table.createTBody();
    for(Map s in songs){
      TableRowElement tr = table_body.insertRow(-1);
      
      TableCellElement td_add = new TableCellElement();
      AnchorElement add_btn = new AnchorElement();
      add_btn.classes.add('btn');
      add_btn.href = "#";
      add_btn.dataAttributes['id'] = s['id'];
      Element plus_icon = new Element.tag("i");
      plus_icon.classes.add('icon-plus');
      add_btn.elements.add(plus_icon);
      add_btn.on.click.add(this._add_btn_clicked);
      td_add.elements.add(add_btn);
      tr.elements.add(td_add);
      
      TableCellElement td_title = new TableCellElement();
      td_title.text = s['title'];
      tr.elements.add(td_title);
      
      TableCellElement td_artist = new TableCellElement();
      td_artist.text = s['artist'];
      tr.elements.add(td_artist);
      
      TableCellElement td_album = new TableCellElement();
      td_album.text = s['album'].toString();
      tr.elements.add(td_album);
    }
    
    this._box.query("#library-results").elements.clear();
    this._box.query("#library-results").elements.add(table);
  }
  
  void _add_btn_clicked(MouseEvent e){
    Element target = e.target;
    if(target.tagName != "BUTTON"){
      target = target.parent;
    }
    String id = target.dataAttributes['id'];
    this._add_callback(id);
  }
}
