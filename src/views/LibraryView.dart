part of udjlib;


class LibraryView extends CompositeView {
  final UdjApp _udjApp;
  
  final LibraryState _state;
  
  LibraryListView _libraryList;
  
  LibraryView(this._udjApp,this._state):super("library-box"){
    _libraryList = new LibraryListView(_udjApp,_state);
    addChild(_libraryList);
  }
  
  void afterRender(Element node){
    watch(_udjApp.state.libraryView,_setLibraryView);
    watch(_udjApp.state.currentPlayer,_resetLibraryView);
    watch(_udjApp.state.searchQuery,_setSearchView);
    watch(_state.results,_updateResults);
    super.afterRender(node);
  }
  
  void _updateResults(e){
    _libraryList.rerender(); 
  }
  
  void _resetLibraryView(e){
    _udjApp.state.libraryView.value = Constants.DEFAULT_LIBRARY_VIEW;
    _state.results.value = null;
  }
  
  void _setLibraryView(e){
    _state.setLibraryView();
  }
  
  void _setSearchView(e){
    if(_udjApp.state.searchQuery.value != null && _udjApp.state.searchQuery.value != ""){
      // set to null so that a new search will still trigger the change of view event.
      _udjApp.state.libraryView.value = null;
      _udjApp.state.libraryView.value = "Search";
    }else{
      _udjApp.state.libraryView.value = Constants.DEFAULT_LIBRARY_VIEW;
    }
  }
}

class LibraryListView extends CompositeView{
  final UdjApp _udjApp;
  
  final LibraryState _state;
  
  LibraryListView(this._udjApp,this._state):super('library-box-results'){
    rerender();
  }
  
  void rerender(){
    removeAllChildren();
    
    if (_state.results.value != null) {
      for (Song s in _state.results.value) {
        SongView view = new SongView(_udjApp,s);
        addChild(view);
      } 
    }
  }
}
