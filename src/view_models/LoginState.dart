part of udjlib;

class LoginState extends UIState{
  final ObservableValue<String> errorMessage;
  
  LoginState():
    super(),
    errorMessage = new ObservableValue<String>(null);
  
}
