part of udjlib;

// PollService
// ============================================================================

/**
 * Service that will get updates from the server.
 */
class PollService {
  final UdjApp _udjApp;
  
  Timer _timer;
  
  // Constructor
  // --------------------------------------------------------------------------
  
  PollService(this._udjApp){
    
  }
  
  // Methods
  // --------------------------------------------------------------------------
  
  /**
   * Starts polling the server.
   * 
   * UdjApp.pollPlayer must have a Timer paramater since Timer.repeating
   * requires a callback with that parameter.
   */
  void start(){
    new Timer.repeating(Constants.POLL_INTERVAL,_udjApp.pollPlayer);
    _udjApp.pollPlayer(null);
  }
  
  /**
   * Stops polling the server.
   */
  void stop(){
    _timer.cancel();
  }
}
