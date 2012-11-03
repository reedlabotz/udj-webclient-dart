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
  
  String toJson(){
    var data = {
      'id': id,
      'username': username,
      'firstName': firstName,
      'lastName': lastName
    };
    return JSON.stringify(data);
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
      'numActiveUsers': numActiveUsers,
      'hasPassword': hasPassword,
      'admins': admins,
      'sizeLimit': sizeLimit
    };
    return data;
  }
}

class Song{
  String id;
  String title;
  String artist;
  String album;
}

class QueueSong extends Song{
  List<User> upvoters;
  List<User> downvoters;
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

