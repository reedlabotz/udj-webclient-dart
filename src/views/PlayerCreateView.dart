part of udjlib;

class PlayerCreateView extends CompositeView {

  final UdjApp _udjApp;  
  final PlayerCreateState _state;
  
  // views
  View _form;
  
  PlayerCreateView(this._udjApp, this._state):super('player-create') {
    _form = new View.html('''
    <form id="player-create-form">
      <input id="player-create-name" placeholder="Player Name">

      <button type="submit" class="btn">Create!</button>
    </form>
    ''');
    addChild(_form);
    
  }
  
  void afterRender(Element node){
  }
  
}
