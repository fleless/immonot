class PlacesResponse {
  String _id;
  String _label;
  String _code;
  String _type;

  PlacesResponse({String id, String label, String code, String type}) {
    this._id = id;
    this._label = label;
    this._code = code;
    this._type = type;
  }

  String get id => _id;
  set id(String id) => _id = id;
  String get label => _label;
  set label(String label) => _label = label;
  String get code => _code;
  set code(String code) => _code = code;
  String get type => _type;
  set type(String type) => _type = type;

  PlacesResponse.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _label = json['label'];
    _code = json['code'];
    _type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['label'] = this._label;
    data['code'] = this._code;
    data['type'] = this._type;
    return data;
  }
}