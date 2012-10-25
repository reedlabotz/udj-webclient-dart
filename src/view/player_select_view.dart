library player_select_view;

import "dart:html";
import "dart:json";
import 'package:js/js.dart' as js;


class PlayerSelectView {
  Element _box;
  Element _content;
  Function _join_btn_clicked_callback;
  
  PlayerSelectView(Element box){
    this._box = box;
    this._content = box.query("#player-select-content");
  }
  
  void register_join_btn_clicked(Function callback){
    this._join_btn_clicked_callback = callback;
  }
  
  void show(){
    js.scoped(() {
      js.context.showPlayerSelectBox();
    });
  }
  
  void hide(){
    js.scoped(() {
      js.context.hidePlayerSelectBox();
    });
  }
  
  void set_content(Element content){
    this._content.elements.clear();
    this._content.elements.add(content);
  }
  
  void list_players(List players){
    TableElement table = new TableElement();
    table.classes.add("table");
    table.classes.add("table-striped");
    
    //create table header
    table.createTHead();
    
    TableRowElement tr_head = new TableRowElement();
    
    TableCellElement td_name = new Element.tag("th");
    td_name.text = "Player Name";
    tr_head.elements.add(td_name);
    
    TableCellElement td_owner = new Element.tag("th");
    td_owner.text = "Owner";
    tr_head.elements.add(td_owner);
    
    TableCellElement td_active = new Element.tag("th");
    td_active.text = "Active Users";
    tr_head.elements.add(td_active);
    
    TableCellElement td_max = new Element.tag("th");
    td_max.text = "Max Users";
    tr_head.elements.add(td_max);
    
    TableCellElement td_join = new Element.tag("th");
    td_join.text = "Join";
    tr_head.elements.add(td_join);
    
    table.tHead.elements.add(tr_head);
    
    //create table body
    var table_body = table.createTBody();
    for(Map p in players){
      TableRowElement tr = table_body.insertRow(-1);
      
      TableCellElement td_name = new TableCellElement();
      td_name.text = p['name'];
      tr.elements.add(td_name);
      
      TableCellElement td_owner = new TableCellElement();
      td_owner.text = p['owner']['username'];
      tr.elements.add(td_owner);
      
      TableCellElement td_active = new TableCellElement();
      td_active.text = p['num_active_users'].toString();
      tr.elements.add(td_active);
      
      TableCellElement td_max = new TableCellElement();
      td_max.text = "∞";
      tr.elements.add(td_max);
      
      TableCellElement td_join = new TableCellElement();
      AnchorElement join_btn = new AnchorElement();
      join_btn.classes.add('btn');
      join_btn.href = "#";
      join_btn.dataAttributes['id'] = p['id'];
      join_btn.dataAttributes['data'] = JSON.stringify(p);
      join_btn.text = "Join";
      join_btn.on.click.add(join_btn_clicked);
      td_join.elements.add(join_btn);
      if(p['has_password']){
        Element i = new Element.tag("i");
        i.classes.add("icon-lock");
        td_join.elements.add(i);
      }
      tr.elements.add(td_join);
    }
    
    this.set_content(table);
  }
  

  void join_btn_clicked(MouseEvent e){
    AnchorElement target = e.target;
    String id = target.dataAttributes['id'];
    Map data = JSON.parse(target.dataAttributes['data']);
    this._join_btn_clicked_callback(id,data);
  }
}

