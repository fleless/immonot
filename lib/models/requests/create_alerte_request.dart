class CreateAlerteRequest {
  String nom;
  String commentaire;
  String token;
  Recherche recherche;

  CreateAlerteRequest({this.nom, this.commentaire, this.token, this.recherche});

  CreateAlerteRequest.fromJson(Map<String, dynamic> json) {
    nom = json['nom'];
    commentaire = json['commentaire'];
    token = json['token'];
    recherche = json['recherche'] != null
        ? new Recherche.fromJson(json['recherche'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nom'] = this.nom;
    data['commentaire'] = this.commentaire;
    data['token'] = this.token;
    if (this.recherche != null) {
      data['recherche'] = this.recherche.toJson();
    }
    return data;
  }
}

class Recherche {
  List<String> references;
  List<String> oidCommunes;
  List<String> departements;
  List<int> rayons;
  List<String> typeVentes;
  List<String> typeBiens;
  List<int> prix;
  List<int> surfaceInterieure;
  List<int> surfaceExterieure;
  List<int> nbPieces;
  List<int> nbChambres;

  Recherche(
      {this.references,
      this.oidCommunes,
      this.departements,
      this.rayons,
      this.typeVentes,
      this.typeBiens,
      this.prix,
      this.surfaceInterieure,
      this.surfaceExterieure,
      this.nbPieces,
      this.nbChambres});

  Recherche.fromJson(Map<String, dynamic> json) {
    references =
        json['references'] == null ? null : json['references'].cast<String>();
    rayons = json["rayons"] == null ? null : json['rayons'].cast<int>();
    surfaceExterieure = json["surfaceExterieure"] == null
        ? null
        : json['surfaceExterieure'].cast<int>();
   surfaceInterieure = json["surfaceInterieure"] == null
        ? null
        : json['surfaceInterieure'].cast<int>();
    nbPieces = json["nbPieces"] == null ? null : json['nbPieces'].cast<int>();
    nbChambres = json["nbChambres"] == null ? null : json['nbChambres'].cast<int>();
    prix = json["prix"] == null ? null : json['prix'].cast<int>();
    departements = json["departements"] == null ? null : json['departements'].cast<String>();
    typeVentes = json["typeVentes"] == null ? null : json['typeVentes'].cast<String>();
    typeBiens = json["typeBiens"] == null ? null : json['typeBiens'].cast<String>();
    oidCommunes = json["oidCommunes"] == null ? null : json['oidCommunes'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['references'] = this.references;
    data['oidCommunes'] = this.oidCommunes;
    data['departements'] = this.departements;
    data['rayons'] = this.rayons;
    data['typeVentes'] = this.typeVentes;
    data['typeBiens'] = this.typeBiens;
    data['prix'] = this.prix;
    data['surfaceInterieure'] = this.surfaceInterieure;
    data['surfaceExterieure'] = this.surfaceExterieure;
    data['nbPieces'] = this.nbPieces;
    data['nbChambres'] = this.nbChambres;
    return data;
  }
}
