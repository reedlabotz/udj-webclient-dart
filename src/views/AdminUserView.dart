part of udjlib;

class AdminUserView extends CompositeView {
  final UdjApp _udjApp;
  
  final AdminUserState _controls;

  AdminUserView(this._udjApp,this._controls):super('useradmin'){
    
  }
  
}
