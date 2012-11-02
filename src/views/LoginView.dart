part of udjlib;

/**
 * The login view that holds the login form.
 */
class LoginView extends CompositeView{
  /// Reference to the main app
  final UdjApp _udjApp;
  
  final LoginState _state;
  
  /// The actual form itself
  View _loginForm;
  
  View _errorMessage;
  
  /**
   * The constructor will build the form.
   */
  LoginView(this._udjApp,this._state):super('login-box'){
    // create login form
    _loginForm = new View.html('''
      <div class="container" id="login-box">
        <div class="row">
          <div class="span4 offset4 loggin-box">
            <form class="well loggin-box-inner" id="login-form">
              <img src="assets/img/logo-big.png" style="width: 96px; height: 96px;">
              <h2>UDJ</h2>
              <div class="alert alert-error login-error" id="login-error" style="display:none;"></div>
              <input type="text" placeholder="Username" id="username" class="input input-medium"><br>
              <input type="password" placeholder="Password" id="password" class="input input-medium"><br>
              <button type="submit" class="btn btn-primary">Login</button>
              <br>
              <br>
              <p>
                <a href="https://www.udjplayer.com/recover/">I forgot my username or password.</a><br>
                <a href="https://www.udjplayer.com/registration/register/">Don't have an account? Create one.</a>
              </p>
            </form>
          </div>
        </div>
      </div>
    ''');
    addChild(_loginForm);
    
    _errorMessage = new View.fromNode(_loginForm.node.query("#login-error"));
    
    watch(_state.errorMessage,_showErrorMessage);
  }
  
  /**
   * Callback when form is submitted.
   */
  void _loginFormSubmitted(Event e){
    e.preventDefault();
    InputElement usernameInput = _loginForm.node.query("#username");
    InputElement passwordInput = _loginForm.node.query("#password");
    var username = usernameInput.value;
    var password = passwordInput.value;
    _state.login(username,password);
  }
  
  /**
   * Add listener after render is done.
   */
  void afterRender(Element node){
    _loginForm.node.query("#login-form").on.submit.add(_loginFormSubmitted);
  }
  
  void _showErrorMessage(e){
    InputElement passwordInput = _loginForm.node.query("#password");
    passwordInput.value = "";
    if(_state.errorMessage.value != null){
      _errorMessage.node.text = _state.errorMessage.value;
      _errorMessage.hidden = false;
    }else{
      _errorMessage.hidden = true;
    }
  }
}
