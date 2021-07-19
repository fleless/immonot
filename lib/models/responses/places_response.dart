  class PlacesResponse {
  String code;
  String codePostal;
  String nom;
  String type;

  PlacesResponse({this.code, this.codePostal, this.nom, this.type});

  PlacesResponse.fromJson(Map<String, dynamic> json) {
  code = json['code'];
  codePostal = json['codePostal'];
  nom = json['nom'];
  type = json['type'];
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['code'] = this.code;
  data['codePostal'] = this.codePostal;
  data['nom'] = this.nom;
  data['type'] = this.type;
  return data;
  }
  }
