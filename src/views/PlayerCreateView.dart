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
      <input id="player-create-zip" placeholder="Postal Code">
      <input id="player-create-country" placeholder="Country">

      <button type="submit" class="btn">Create!</button>
    </form>
    ''');
    addChild(_form);
    
  }
  
  void afterRender(Element node){
    // events
    _form.node.on.submit.add((e) {
      e.preventDefault();
      
      // TODO: client side error checking
      
      Map playerAttrs = new Map();
      Map location = new Map();
      
      // populate location map
      InputElement zip = _form.node.query("#player-create-zip");
      if (zip.value != "") {
        location['postal_code'] = zip.value;
      }
      InputElement country = _form.node.query("#player-create-country");
      if (country.value != "") {
        location['country'] = country.value;
      }
      
      // populate playerAttrs map
      if (location.isEmpty == false) { // add location map
        playerAttrs['location'] = location;
      }
      InputElement name = _form.node.query("#player-create-name");
      if (name.value != "") { // required
        playerAttrs['name'] = name.value;
      }

      _state.formSubmit(playerAttrs);
    });
  }
  
}
