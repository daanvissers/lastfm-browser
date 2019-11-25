import 'dart:convert';

RecentTrack recentTrackFromJson(String str) =>
    RecentTrack.fromJson(json.decode(str));

String recentTrackToJson(RecentTrack data) => json.encode(data.toJson());

class RecentTrack {
  Album artist;
  Album album;
  List<Image> image;
  String streamable;
  Date date;
  String url;
  String name;
  String mbid;

  RecentTrack({
    this.artist,
    this.album,
    this.image,
    this.streamable,
    this.date,
    this.url,
    this.name,
    this.mbid,
  });

  factory RecentTrack.fromJson(Map<String, dynamic> json) => RecentTrack(
        artist: Album.fromJson(json["artist"]),
        album: Album.fromJson(json["album"]),
        image: List<Image>.from(json["image"].map((x) => Image.fromJson(x))),
        streamable: json["streamable"],
        date: Date.fromJson(json["date"]),
        url: json["url"],
        name: json["name"],
        mbid: json["mbid"],
      );

  Map<String, dynamic> toJson() => {
        "artist": artist.toJson(),
        "album": album.toJson(),
        "image": List<dynamic>.from(image.map((x) => x.toJson())),
        "streamable": streamable,
        "date": date.toJson(),
        "url": url,
        "name": name,
        "mbid": mbid,
      };
}

class Album {
  String mbid;
  String text;

  Album({
    this.mbid,
    this.text,
  });

  factory Album.fromJson(Map<String, dynamic> json) => Album(
        mbid: json["mbid"],
        text: json["#text"],
      );

  Map<String, dynamic> toJson() => {
        "mbid": mbid,
        "#text": text,
      };
}

class Date {
  String uts;
  String text;

  Date({
    this.uts,
    this.text,
  });

  factory Date.fromJson(Map<String, dynamic> json) => Date(
        uts: json["uts"],
        text: json["#text"],
      );

  Map<String, dynamic> toJson() => {
        "uts": uts,
        "#text": text,
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
