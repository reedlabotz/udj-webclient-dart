part of udjlib;

class User{
  int id;
  String username;
  String firstName;
  String lastName;
  
  User(this.id, this.username, this.firstName, this.lastName);
}

class Player{
  int id;
  User owner;
  String name;
  int numActiveUsers;
  bool hasPassword;
  List<User> admins;
  int sizeLimit;
}

class Song{
  int id;
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
  int user_id;
  String username;
  
  Session(this.ticket_hash, this.user_id, this.username);
}

