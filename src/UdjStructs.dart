part of udjlib;

class User{
  String id;
  String username;
  String firstName;
  String lastName;
  
  User(this.id, this.username, this.firstName, this.lastName);
  
  User.fromJson(Map data){
    id = data['id'];
    username = data['username'];
    firstName = data['first_name'];
    lastName = data['last_name'];
  }
  
  Map toJson(){
    var data = {
      'id': id,
      'username': username,
      'first_name': firstName,
      'last_name': lastName
    };
    return data;
  }

}

class Player{
  String id;
  User owner;
  String name;
  int numActiveUsers;
  bool hasPassword;
  List<User> admins;
  int sizeLimit;
  
  Player.fromJson(Map data){
    id = data['id'];
    owner = new User.fromJson(data['owner']);
    name = data['name'];
    numActiveUsers = data['num_active_users'];
    hasPassword = data['has_password'];
    admins = new List<User>();
    for (var adminData in data['admins']) {
      admins.add(new User.fromJson(adminData));
    }
    sizeLimit = data['size_limit'];
  }
  
  Map toJson(){
    var data = {
      'id': id,
      'owner': owner,
      'name': name,
      'num_active_users': numActiveUsers,
      'has_password': hasPassword,
      'admins': admins,
      'size_limit': sizeLimit
    };
    return data;
  }
}

class Song{
  String id;
  String title;
  String artist;
  String album;
  
  Song.fromJson(Map data){
    id = data['id'];
    title = data['title'];
    artist = data['artist'];
    album = data['album'];
  }
}

class QueueSong extends Song{
  List<User> upvoters;
  List<User> downvoters;
  
  QueueSong.fromJson(Map data):super.fromJson(data){
    for(var u in data['upvoters']){
      upvoters.add(new User.fromJson(u));
    }
    
    for(var d in data['downvoters']){
      downvoters.add(new User.fromJson(d));
    }
  }
}

class Session{
  String ticket_hash;
  String user_id;
  String username;
  
  Session(this.ticket_hash, this.user_id, this.username);
  
  Session.fromJson(Map data){
    this.ticket_hash = data['ticket_hash'];
    this.user_id = data['user_id'];
    this.username = data['username'];
  }
  
  Map toJson(){
    var data = {
      'ticket_hash': ticket_hash,
      'user_id': user_id,
      'username': username
    };
    return data;
  }
}

