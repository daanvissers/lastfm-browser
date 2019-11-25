import 'dart:convert';

Track trackFromJson(String str) => Track.fromJson(json.decode(str));

String trackToJson(Track data) => json.encode(data.toJson());

class Track {
  TrackClass track;

  Track({
    this.track,
  });

  factory Track.fromJson(Map<String, dynamic> json) => Track(
        track: TrackClass.fromJson(json["track"]),
      );

  Map<String, dynamic> toJson() => {
        "track": track.toJson(),
      };
}

class TrackClass {
  String name;
  String mbid;
  String url;
  String duration;
  Streamable streamable;
  String listeners;
  String playcount;
  Artist artist;
  Album album;
  Toptags toptags;
  Wiki wiki;

  TrackClass({
    this.name,
    this.mbid,
    this.url,
    this.duration,
    this.streamable,
    this.listeners,
    this.playcount,
    this.artist,
    this.album,
    this.toptags,
    this.wiki,
  });

  factory TrackClass.fromJson(Map<String, dynamic> json) => TrackClass(
        name: json["name"],
        mbid: json["mbid"],
        url: json["url"],
        duration: json["duration"],
        streamable: Streamable.fromJson(json["streamable"]),
        listeners: json["listeners"],
        playcount: json["playcount"],
        artist: Artist.fromJson(json["artist"]),
        album: Album.fromJson(json["album"]),
        toptags: Toptags.fromJson(json["toptags"]),
        wiki: Wiki.fromJson(json["wiki"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "mbid": mbid,
        "url": url,
        "duration": duration,
        "streamable": streamable.toJson(),
        "listeners": listeners,
        "playcount": playcount,
        "artist": artist.toJson(),
        "album": album.toJson(),
        "toptags": toptags.toJson(),
        "wiki": wiki.toJson(),
      };
}

class Album {
  String artist;
  String title;
  String mbid;
  String url;
  List<Image> image;
  Attr attr;

  Album({
    this.artist,
    this.title,
    this.mbid,
    this.url,
    this.image,
    this.attr,
  });

  factory Album.fromJson(Map<String, dynamic> json) => Album(
        artist: json["artist"],
        title: json["title"],
        mbid: json["mbid"],
        url: json["url"],
        image: List<Image>.from(json["image"].map((x) => Image.fromJson(x))),
        attr: Attr.fromJson(json["@attr"]),
      );

  Map<String, dynamic> toJson() => {
        "artist": artist,
        "title": title,
        "mbid": mbid,
        "url": url,
        "image": List<dynamic>.from(image.map((x) => x.toJson())),
        "@attr": attr.toJson(),
      };
}

class Attr {
  String position;

  Attr({
    this.position,
  });

  factory Attr.fromJson(Map<String, dynamic> json) => Attr(
        position: json["position"],
      );

  Map<String, dynamic> toJson() => {
        "position": position,
      };
}

class Image {
  String text;
  String size;

  Image({
    this.text,
    this.size,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        text: json["#text"],
        size: json["size"],
      );

  Map<String, dynamic> toJson() => {
        "#text": text,
        "size": size,
      };
}

class Artist {
  String name;
  String mbid;
  String url;

  Artist({
    this.name,
    this.mbid,
    this.url,
  });

  factory Artist.fromJson(Map<String, dynamic> json) => Artist(
        name: json["name"],
        mbid: json["mbid"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "mbid": mbid,
        "url": url,
      };
}

class Streamable {
  String text;
  String fulltrack;

  Streamable({
    this.text,
    this.fulltrack,
  });

  factory Streamable.fromJson(Map<String, dynamic> json) => Streamable(
        text: json["#text"],
        fulltrack: json["fulltrack"],
      );

  Map<String, dynamic> toJson() => {
        "#text": text,
        "fulltrack": fulltrack,
      };
}

class Toptags {
  List<Tag> tag;

  Toptags({
    this.tag,
  });

  factory Toptags.fromJson(Map<String, dynamic> json) => Toptags(
        tag: List<Tag>.from(json["tag"].map((x) => Tag.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "tag": List<dynamic>.from(tag.map((x) => x.toJson())),
      };
}

class Tag {
  String name;
  String url;

  Tag({
    this.name,
    this.url,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        name: json["name"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
      };
}

class Wiki {
  String published;
  String summary;
  String content;

  Wiki({
    this.published,
    this.summary,
    this.content,
  });

  factory Wiki.fromJson(Map<String, dynamic> json) => Wiki(
        published: json["published"],
        summary: json["summary"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "published": published,
        "summary": summary,
        "content": content,
      };
}
