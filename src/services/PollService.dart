part of udjlib;


class PollService {
  final UdjApp _udjApp;
  
  Timer _timer;
  
   PollService(this._udjApp){
    
  }
   
  void start(){
    new Timer.repeating(Constants.POLL_INTERVAL,_udjApp.pollPlayer);
    _udjApp.pollPlayer(null);
  }
  
  void stop(){
    _timer.cancel();
  }
}
