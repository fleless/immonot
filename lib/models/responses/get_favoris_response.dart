import 'DetailAnnonceResponse.dart';

class GetFavorisResponse {
  List<Content> content;
  Pageable pageable;
  num totalElements;
  num totalPages;
  bool last;
  num number;
  Sort sort;
  num size;
  num numberOfElements;
  bool first;
  bool empty;

  GetFavorisResponse(
      {this.content,
      this.pageable,
      this.totalElements,
      this.totalPages,
      this.last,
      this.number,
      this.sort,
      this.size,
      this.numberOfElements,
      this.first,
      this.empty});

  GetFavorisResponse.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = new List<Content>();
      json['content'].forEach((v) {
        content.add(new Content.fromJson(v));
      });
    }
    pageable = json['pageable'] != null
        ? new Pageable.fromJson(json['pageable'])
        : null;
    totalElements = json['totalElements'];
    totalPages = json['totalPages'];
    last = json['last'];
    number = json['number'];
    sort = json['sort'] != null ? new Sort.fromJson(json['sort']) : null;
    size = json['size'];
    numberOfElements = json['numberOfElements'];
    first = json['first'];
    empty = json['empty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.content != null) {
      data['content'] = this.content.map((v) => v.toJson()).toList();
    }
    if (this.pageable != null) {
      data['pageable'] = this.pageable.toJson();
    }
    data['totalElements'] = this.totalElements;
    data['totalPages'] = this.totalPages;
    data['last'] = this.last;
    data['number'] = this.number;
    if (this.sort != null) {
      data['sort'] = this.sort.toJson();
    }
    data['size'] = this.size;
    data['numberOfElements'] = this.numberOfElements;
    data['first'] = this.first;
    data['empty'] = this.empty;
    return data;
  }
}

class Content {
  num oidFavori;
  String oidAnnonce;
  bool alertePrix;
  Annonce annonce;

  Content({this.oidFavori, this.oidAnnonce, this.alertePrix, this.annonce});

  Content.fromJson(Map<String, dynamic> json) {
    oidFavori = json['oidFavori'];
    oidAnnonce = json['oidAnnonce'];
    alertePrix = json['alertePrix'];
    annonce =
        json['annonce'] != null ? new Annonce.fromJson(json['annonce']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['oidFavori'] = this.oidFavori;
    data['oidAnnonce'] = this.oidAnnonce;
    data['alertePrix'] = this.alertePrix;
    if (this.annonce != null) {
      data['annonce'] = this.annonce.toJson();
    }
    return data;
  }
}

class Annonce {
  String oidAnnonce;
  String oidNotaire;
  String typeVente;
  String typeVenteCode;
  String typeBien;
  String typeBienCode;
  bool affichePrix;
  String prixLigne1;
  String prixLigne2;
  String prixLigne3;
  String titre;
  String descriptif;
  bool afficheCommune;
  bool coupDeCoeur;
  Commune commune;
  Photo photo;
  Caracteristiques caracteristiques;
  Contact contact;

  Annonce(
      {this.oidAnnonce,
      this.oidNotaire,
      this.typeVente,
      this.typeVenteCode,
      this.typeBien,
      this.typeBienCode,
      this.affichePrix,
      this.prixLigne1,
      this.prixLigne2,
      this.prixLigne3,
        this.titre,
      this.descriptif,
      this.afficheCommune,
      this.coupDeCoeur,
      this.commune,
      this.photo,
      this.caracteristiques,
      this.contact});

  Annonce.fromJson(Map<String, dynamic> json) {
    oidAnnonce = json['oidAnnonce'];
    oidNotaire = json['oidNotaire'];
    typeVente = json['typeVente'];
    typeVenteCode = json['typeVenteCode'];
    typeBien = json['typeBien'];
    typeBienCode = json['typeBienCode'];
    affichePrix = json['affichePrix'];
    prixLigne1 = json['prixLigne1'];
    prixLigne2 = json['prixLigne2'];
    prixLigne3 = json['prixLigne3'];
    titre = json['titre'];
    descriptif = json['descriptif'];
    afficheCommune = json['afficheCommune'];
    coupDeCoeur = json['coupDeCoeur'];
    commune =
        json['commune'] != null ? new Commune.fromJson(json['commune']) : null;
    photo = json['photo'] != null ? new Photo.fromJson(json['photo']) : null;
    caracteristiques = json['caracteristiques'] != null
        ? new Caracteristiques.fromJson(json['caracteristiques'])
        : null;
    contact =
        json['contact'] != null ? new Contact.fromJson(json['contact']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['oidAnnonce'] = this.oidAnnonce;
    data['oidNotaire'] = this.oidNotaire;
    data['typeVente'] = this.typeVente;
    data['typeVenteCode'] = this.typeVenteCode;
    data['typeBien'] = this.typeBien;
    data['typeBienCode'] = this.typeBienCode;
    data['affichePrix'] = this.affichePrix;
    data['prixLigne1'] = this.prixLigne1;
    data['prixLigne2'] = this.prixLigne2;
    data['prixLigne3'] = this.prixLigne3;
    data['titre'] = this.titre;
    data['descriptif'] = this.descriptif;
    data['afficheCommune'] = this.afficheCommune;
    data['coupDeCoeur'] = this.coupDeCoeur;
    if (this.commune != null) {
      data['commune'] = this.commune.toJson();
    }
    if (this.photo != null) {
      data['photo'] = this.photo.toJson();
    }
    if (this.caracteristiques != null) {
      data['caracteristiques'] = this.caracteristiques.toJson();
    }
    if (this.contact != null) {
      data['contact'] = this.contact.toJson();
    }
    return data;
  }
}

class Commune {
  String code;
  String nom;
  String codePostal;
  num latitude;
  num longitude;

  Commune(
      {this.code, this.nom, this.codePostal, this.latitude, this.longitude});

  Commune.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    nom = json['nom'];
    codePostal = json['codePostal'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['nom'] = this.nom;
    data['codePostal'] = this.codePostal;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class Photo {
  num count;
  String principale;
  String principaleThumb;

  Photo({this.count, this.principale, this.principaleThumb});

  Photo.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    principale = json['principale'];
    principaleThumb = json['principaleThumb'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['principale'] = this.principale;
    data['principaleThumb'] = this.principaleThumb;
    return data;
  }
}

class Caracteristiques {
  num nbPieces;
  num nbChambres;
  num surfaceHabitable;
  num surfaceTerrain;

  Caracteristiques(
      {this.nbPieces,
      this.nbChambres,
      this.surfaceHabitable,
      this.surfaceTerrain});

  Caracteristiques.fromJson(Map<String, dynamic> json) {
    nbPieces = json['nbPieces'];
    nbChambres = json['nbChambres'];
    surfaceHabitable = json['surfaceHabitable'];
    surfaceTerrain = json['surfaceTerrain'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nbPieces'] = this.nbPieces;
    data['nbChambres'] = this.nbChambres;
    data['surfaceHabitable'] = this.surfaceHabitable;
    data['surfaceTerrain'] = this.surfaceTerrain;
    return data;
  }
}

class Pageable {
  Sort sort;
  num offset;
  num pageNumber;
  num pageSize;
  bool paged;
  bool unpaged;

  Pageable(
      {this.sort,
      this.offset,
      this.pageNumber,
      this.pageSize,
      this.paged,
      this.unpaged});

  Pageable.fromJson(Map<String, dynamic> json) {
    sort = json['sort'] != null ? new Sort.fromJson(json['sort']) : null;
    offset = json['offset'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    paged = json['paged'];
    unpaged = json['unpaged'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sort != null) {
      data['sort'] = this.sort.toJson();
    }
    data['offset'] = this.offset;
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    data['paged'] = this.paged;
    data['unpaged'] = this.unpaged;
    return data;
  }
}

class Sort {
  bool sorted;
  bool unsorted;
  bool empty;

  Sort({this.sorted, this.unsorted, this.empty});

  Sort.fromJson(Map<String, dynamic> json) {
    sorted = json['sorted'];
    unsorted = json['unsorted'];
    empty = json['empty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sorted'] = this.sorted;
    data['unsorted'] = this.unsorted;
    data['empty'] = this.empty;
    return data;
  }
}
