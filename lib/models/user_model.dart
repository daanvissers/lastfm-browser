class User {
  final String name;
  final String key;
  final int subscriber;

  User({this.name, this.key, this.subscriber});

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        key = json['key'],
        subscriber = json['subscriber'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['key'] = this.key;
    data['subscriber'] = this.subscriber;
    return data;
  }
}
