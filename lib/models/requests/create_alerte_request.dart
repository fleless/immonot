class CreateAlerteRequest {
  String nom;
  String commentaire;
  String token;
  Recherche recherche;
  bool push;
  bool mail;

  CreateAlerteRequest(
      {this.nom,
      this.commentaire,
      this.token,
      this.recherche,
      this.push,
      this.mail});

  CreateAlerteRequest.fromJson(Map<String, dynamic> json) {
    nom = json['nom'];
    commentaire = json['commentaire'];
    token = json['token'];
    recherche = json['recherche'] != null
        ? new Recherche.fromJson(json['recherche'])
        : null;
    push = json['push'];
    mail = json['mail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nom'] = this.nom;
    data['commentaire'] = this.commentaire;
    data['token'] = this.token;
    if (this.recherche != null) {
      data['recherche'] = this.recherche.toJson();
    }
    data['push'] = this.push;
    data['mail'] = this.mail;
    return data;
  }
}

class Recherche {
  List<String> references;
  List<String> oidCommunes;
  List<String> departements;
  List<num> rayons;
  List<String> typeVentes;
  List<String> typeBiens;
  List<num> prix;
  List<num> surfaceInterieure;
  List<num> surfaceExterieure;
  List<num> nbPieces;
  List<num> nbChambres;

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
    rayons = json["rayons"] == null ? null : json['rayons'].cast<num>();
    surfaceExterieure = json["surfaceExterieure"] == null
        ? null
        : json['surfaceExterieure'].cast<num>();
    surfaceInterieure = json["surfaceInterieure"] == null
        ? null
        : json['surfaceInterieure'].cast<num>();
    nbPieces = json["nbPieces"] == null ? null : json['nbPieces'].cast<num>();
    nbChambres =
        json["nbChambres"] == null ? null : json['nbChambres'].cast<num>();
    prix = json["prix"] == null ? null : json['prix'].cast<num>();
    departements = json["departements"] == null
        ? null
        : json['departements'].cast<String>();
    typeVentes =
        json["typeVentes"] == null ? null : json['typeVentes'].cast<String>();
    typeBiens =
        json["typeBiens"] == null ? null : json['typeBiens'].cast<String>();
    oidCommunes =
        json["oidCommunes"] == null ? null : json['oidCommunes'].cast<String>();
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
