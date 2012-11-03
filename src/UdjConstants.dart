part of udjlib;

/**
 * Constants used throughout the app.
 */
class Constants{
  static const String API_URL = "https://www.udjplayer.com/udj/0_6";
  static const int POLL_INTERVAL = 2000;
  static const String DEFAULT_LIBRARY_VIEW = "Random";
  static const String MAX_RESULTS = '50';
}

/**
 * Constants used to represent errors.
 */
class Errors{
  // general
  static const UNKOWN = null;
  
  // requests
  static const String INVALID_CONTENT_TYPE = "invalid-content-type";
  static const String INVALID_JSON = "invalid-json";
  
  // location
  static const String INVALID_LOCATION = "invalid-location";
  static const String LOCATION_NOT_FOUND = "location-not-found";
  
  // joining a player
  static const String PLAYER_BANNED = "player-banned";
  static const String PLAYER_FULL = "player-full";
  
  // creating a player
  static const String CREATE_PLAYER_NO_NAME = "no-name";
  static const String CREATE_PLAYER_NAME_TAKEN = "name-taken";
  static const String CREATE_PLAYER_INVALID_PSWD = "invalid-password";
  static const String CREATE_PLAYER_UNKOWN_SORT = "unkown-sorting-algorithm";

  
  
      
}
