import 'package:flutter/foundation.dart';

class Profile {
  @required
  final int id;
  @required
  final String username;
  @required
  final String imgUrl;

  Profile({
    this.id,
    this.username,
    this.imgUrl,
  });

  Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['username'] = username;
    map['imgUrl'] = imgUrl;

    return map;
  }

  Profile.fromDb(Map<String, dynamic> map)
      : id = map['id'],
        username = map['username'],
        imgUrl = map['imgUrl'];
}
