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
    _admins.addChild(new View.html('''
    <div class="message">Click to kick. :)</div>
    '''));
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
      
      if (users != null) {
        _users.addChild(new View.html('''
        <div class="message">Click to kick. :)</div>
        '''));
        
        for (User user in users) {
          View userView = new View.html('''
          <div class="useradmin-users-user" data-user-id="${user.id}">
            <span>${user.username}</span>
          </div>
          ''');
          _users.addChild(userView);
          userView.addOnClick(_kickUser);
        } 
      } else {
        _users.addChild(new View.html('''
          <div class="error">There was an error loading the list of users in this player.</div>
        '''));
      }
      // TODO: handle error message with a watcher?
      // TODO: handle users and admins list as separate CompositeView child classes?
      // TODO: make generic CompositeView child class to handle list of things, with an input list(List<T>) method?
      
    });
    
    // events
    //  - some are setup in content creation
    
    // watchers 
  }
  
  // Event Handlers & Watchers
  // --------------------------------------------------------------------------
  
  /**
   * Kick the user an admin clicks on.
   */
  void _kickUser(Event e) {
    // find the right element
    Element target = e.target;
    while (target.classes.contains("useradmin-users-user") == false) {
      target = target.parent;
    }
    
    _controls.kickUser(target.dataAttributes['user-id'], () {
      target.remove();
    });
  }
  
}
