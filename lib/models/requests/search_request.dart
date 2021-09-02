class SearchRequest {
  String typeVentes;
  String references;
  String oidCommunes;
  String departements;
  num rayons;
  String typeBiens;
  String prix;
  String surfaceInterieure;
  String surfaceExterieure;
  String nbPieces;
  String nbChambres;

  SearchRequest(
      {this.typeVentes,
      this.references,
      this.oidCommunes,
      this.departements,
      this.rayons,
      this.typeBiens,
      this.prix,
      this.surfaceInterieure,
      this.surfaceExterieure,
      this.nbPieces,
      this.nbChambres});

  SearchRequest.fromJson(Map<String, dynamic> json) {
    typeVentes = json['typeVentes'];
    references = json['references'];
    oidCommunes = json['oidCommunes'];
    departements = json['departements'];
    rayons = json['rayons'];
    typeBiens = json['typeBiens'];
    prix = json['prix'];
    surfaceInterieure = json['surfaceInterieure'];
    surfaceExterieure = json['surfaceExterieure'];
    nbPieces = json['nbPieces'];
    nbChambres = json['nbChambres'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['typeVentes'] = this.typeVentes;
    data['references'] = this.references;
    data['oidCommunes'] = this.oidCommunes;
    data['departements'] = this.departements;
    data['rayons'] = this.rayons;
    data['typeBiens'] = this.typeBiens;
    data['prix'] = this.prix;
    data['surfaceInterieure'] = this.surfaceInterieure;
    data['surfaceExterieure'] = this.surfaceExterieure;
    data['nbPieces'] = this.nbPieces;
    data['nbChambres'] = this.nbChambres;
    return data;
  }
}
