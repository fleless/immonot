class ThemeResponse {
  int id;
  String libelle;

  ThemeResponse({this.id, this.libelle});

  ThemeResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'] == null ? null : json["id"];
    libelle = json["libelle"] == null ? null : json["libelle"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['libelle'] = this.libelle;
    return data;
  }
}
