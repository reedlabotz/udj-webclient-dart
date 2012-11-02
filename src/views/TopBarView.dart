part of udjlib;
/*
 * The top bar which holds the library navigation and search bar
 */
class TopBarView extends CompositeView {
  /// reference to the main app
  final UdjApp _udjApp;
  
  /// The menue at the top to choose library section
  SliderMenu _librarySelectView;
  
  /// Holder for search box
  View _searchBoxView;
  
  /*
   * Main constructor initalizes child views
   */
  TopBarView(this._udjApp):super('top-bar'){
    // Create the logo holder
    var logoView = new View.html('''
      <div class="logo-holder"><img src="assets/img/logo.png"></div>
    ''');
    addChild(logoView);
    
    // Create the library view menue
    var menuItems = ['Random','Artists','Recent'];
    _librarySelectView = new SliderMenu(menuItems,_onSelectLibraryView);
    addChild(_librarySelectView);
    
    // Create search box
    _searchBoxView = new View.html('''
      <div class="search-box-holder">
        <form class="form-search main-search" id="search-form">
          <div class="input-append">
            <input type="text" class="span2 search-query" id="search-input" placeholder="Search">
            <button type="submit" class="btn"><i class="icon-search"></i></button>
          </div>
        </form>
      </div>
    ''');
    addChild(_searchBoxView);
  }  
  
  /*
   * Callback for when a new library view is selected
   */
  void _onSelectLibraryView(String menuText){
    _udjApp.state.libraryView.value = menuText;
  }
  
  /**
   * Callback for when the form is submitted.
   */
  void _searchFormSubmitted(Event e){
    e.preventDefault();
    InputElement searchBox = _searchBoxView.node.query("#search-input");
    _udjApp.state.searchTerm.value = searchBox.value;
  }
  
  /* 
   * Callback after the node has been rendered. Add watchers and callbacks.
   */
  void afterRender(Element node){
    _searchBoxView.node.query("#search-form").on.submit.add(_searchFormSubmitted);
  }
}
