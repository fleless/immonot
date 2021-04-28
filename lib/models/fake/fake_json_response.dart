class FakeJsonResponse {
  String _genre;
  String _type;
  String _prize;
  String _location;
  String _photo;

  FakeJsonResponse(
      {String genre,
        String type,
        String prize,
        String location,
        String photo}) {
    this._genre = genre;
    this._type = type;
    this._prize = prize;
    this._location = location;
    this._photo = photo;
  }

  String get genre => _genre;
  set genre(String genre) => _genre = genre;
  String get type => _type;
  set type(String type) => _type = type;
  String get prize => _prize;
  set prize(String prize) => _prize = prize;
  String get location => _location;
  set location(String location) => _location = location;
  String get photo => _photo;
  set photo(String photo) => _photo = photo;

  FakeJsonResponse.fromJson(Map<String, dynamic> json) {
    _genre = json['genre'];
    _type = json['type'];
    _prize = json['prize'];
    _location = json['location'];
    _photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['genre'] = this._genre;
    data['type'] = this._type;
    data['prize'] = this._prize;
    data['location'] = this._location;
    data['photo'] = this._photo;
    return data;
  }
}
