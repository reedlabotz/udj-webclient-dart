part of udjlib;

// AdminUserView
// ============================================================================

class AdminUserView extends CompositeView {
  final UdjApp _udjApp;
  
  final AdminUserState _controls;

  CompositeView _users;
  CompositeView _admins;
  
  // Constructors
  // --------------------------------------------------------------------------
  
  /**
   * Create the [AdminUserView].
   */
  AdminUserView(this._udjApp,this._controls):super('useradmin'){
    _users = new CompositeView('useradmin-users');
    _users.addChild(new View.html('''
    <div class="loading">Loading...</div>
    '''));
    
    _admins = new CompositeView('useradmin-admins');
    for (User admin in _udjApp.state.currentPlayer.value.admins) {
      View admin = new View.html('''
      <div class="useradmin-admins-admin">
        <span>${admin.username}</span>
      </div>
      ''');
    }
  }
    
  /**
   * Populate content generated from an ajax call.
   * Setup events and watchers.
   */
  void afterRender(Element node){
    // populate ajax content
    _controls.getCurrentUsers((List<User> users) {
      _users.removeAllChildren();
      
      for (User user in users) {
        _users.addChild(new View.html('''
        <div class="useradmin-users-user">
          <span>${user.username}</span>
        </div>
        '''));
      }
    });
    
    // events
    // watchers 
  }
  
}
