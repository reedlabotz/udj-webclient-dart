part of udjlib;

// PlayerCreateView
// ============================================================================

class PlayerCreateView extends CompositeView {
  final UdjApp _udjApp;
  
  final PlayerCreateState _state;
  
  View _form;
  
  // Constructors
  // --------------------------------------------------------------------------
  PlayerCreateView(this._udjApp, this._state):super('player-create container') {
    CompositeView formRow = new CompositeView('row');
    CompositeView formSpan = new CompositeView('span4 offset4 player-create-wrap');
    formRow.addChild(formSpan);
    
    _form = new View.html('''
    <form id="player-create-form" class="well player-create-form">
      <h3>Create Your Player</h3>

      <div>
        <input id="player-create-name" placeholder="Player Name">
      </div>
      <div>
        <input id="player-create-zip" placeholder="Postal Code">
      </div>
      <div>
        <input id="player-create-country" placeholder="Country">
      </div>

      <button type="submit" class="btn">Create!</button>
    </form>
    ''');
    formSpan.addChild(_form);
    
    addChild(formRow);
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
