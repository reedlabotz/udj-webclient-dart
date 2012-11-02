library requesthelper;

import "dart:uri";

class RequestHelper {
  static String encodeMap(Map data) {
    return Strings.join(data.keys.map((k) {
      return '${encodeUriComponent(k)}=${encodeUriComponent(data[k])}';
    }), '&');
  } 
}
