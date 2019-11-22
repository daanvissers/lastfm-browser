import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  UserClass user;

  User({
    this.user,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        user: UserClass.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
      };
}

class UserClass {
  String playlists;
  String playcount;
  String gender;
  String name;
  String subscriber;
  String url;
  String country;
  List<Image> image;
  Registered registered;
  String type;
  String age;
  String bootstrap;
  String realname;

  UserClass({
    this.playlists,
    this.playcount,
    this.gender,
    this.name,
    this.subscriber,
    this.url,
    this.country,
    this.image,
    this.registered,
    this.type,
    this.age,
    this.bootstrap,
    this.realname,
  });

  factory UserClass.fromJson(Map<String, dynamic> json) => UserClass(
        playlists: json["playlists"],
        playcount: json["playcount"],
        gender: json["gender"],
        name: json["name"],
        subscriber: json["subscriber"],
        url: json["url"],
        country: json["country"],
        image: List<Image>.from(json["image"].map((x) => Image.fromJson(x))),
        registered: Registered.fromJson(json["registered"]),
        type: json["type"],
        age: json["age"],
        bootstrap: json["bootstrap"],
        realname: json["realname"],
      );

  Map<String, dynamic> toJson() => {
        "playlists": playlists,
        "playcount": playcount,
        "gender": gender,
        "name": name,
        "subscriber": subscriber,
        "url": url,
        "country": country,
        "image": List<dynamic>.from(image.map((x) => x.toJson())),
        "registered": registered.toJson(),
        "type": type,
        "age": age,
        "bootstrap": bootstrap,
        "realname": realname,
      };
}

class Image {
  String size;
  String text;

  Image({
    this.size,
    this.text,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        size: json["size"],
        text: json["#text"],
      );

  Map<String, dynamic> toJson() => {
        "size": size,
        "#text": text,
      };
}

class Registered {
  String unixtime;
  int text;

  Registered({
    this.unixtime,
    this.text,
  });

  factory Registered.fromJson(Map<String, dynamic> json) => Registered(
        unixtime: json["unixtime"],
        text: json["#text"],
      );

  Map<String, dynamic> toJson() => {
        "unixtime": unixtime,
        "#text": text,
      };
}
