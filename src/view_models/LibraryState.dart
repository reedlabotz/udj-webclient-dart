part of udjlib;


class LibraryState extends UIState {
  final UdjApp _udjApp; 
 
  final ObservableValue<List> results;
  
  LibraryState(this._udjApp):super(),
    results = new ObservableValue<List>(null){
    
  }
  
  void setLibraryView(){
    if(_udjApp.state.currentPlayer.value != null){
      if(_udjApp.state.libraryView.value == "Random"){
        _udjApp.service.getRandomLibrary(_udjApp.state.currentPlayer.value.id, _processLibraryResults); 
      }else if(_udjApp.state.libraryView.value == "Recent"){
        _udjApp.service.getRecentLibrary(_udjApp.state.currentPlayer.value.id, _processLibraryResults);
      }else if(_udjApp.state.libraryView.value == "Search"){
        _udjApp.service.getSearchLibrary(_udjApp.state.currentPlayer.value.id,_udjApp.state.searchQuery.value,
            _processLibraryResults);
      }
    }
  }
    
  void _processLibraryResults(Map res){
    List songs = new List<Song>();
    for(var s in res['data']){
      songs.add(new Song.fromJson(s));
    }
    
    results.value = songs;
  }
}
