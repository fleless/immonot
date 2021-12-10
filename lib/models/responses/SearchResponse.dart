import 'package:immonot/models/responses/DetailAnnonceResponse.dart';

class SearchResponse {
  List<Content> content;
  Pageable pageable;
  num totalPages;
  num totalElements;
  bool last;
  num number;
  Sort sort;
  num size;
  num numberOfElements;
  bool first;
  bool empty;

  SearchResponse(
      {this.content,
      this.pageable,
      this.totalPages,
      this.totalElements,
      this.last,
      this.number,
      this.sort,
      this.size,
      this.numberOfElements,
      this.first,
      this.empty});

  SearchResponse.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = new List<Content>();
      json['content'].forEach((v) {
        content.add(new Content.fromJson(v));
      });
    }
    pageable = json['pageable'] != null
        ? new Pageable.fromJson(json['pageable'])
        : null;
    totalPages = json['totalPages'];
    totalElements = json['totalElements'];
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
    data['totalPages'] = this.totalPages;
    data['totalElements'] = this.totalElements;
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
  String oidAnnonce;
  String oidNotaire;
  String typeVente;
  String typeVenteCode;
  bool coupDeCoeur;
  bool suiviPrix;
  bool prixEnBaisse;
  bool favori;
  String typeBien;
  String typeBienCode;
  bool affichePrix;
  String prixLigne1;
  String prixLigne2;
  String prixLigne3;
  bool afficheCommune;
  Commune commune;
  Photo photo;
  Caracteristiques caracteristiques;
  Contactt contact;

  Content(
      {this.oidAnnonce,
      this.oidNotaire,
      this.typeVente,
      this.typeVenteCode,
      this.coupDeCoeur,
      this.suiviPrix,
      this.prixEnBaisse,
      this.typeBien,
      this.favori,
      this.typeBienCode,
      this.affichePrix,
      this.prixLigne1,
      this.prixLigne2,
      this.prixLigne3,
      this.afficheCommune,
      this.commune,
      this.photo,
      this.contact,
      this.caracteristiques});

  Content.fromJson(Map<String, dynamic> json) {
    oidAnnonce = json['oidAnnonce'];
    oidNotaire = json['oidNotaire'];
    typeVente = json['typeVente'];
    typeVenteCode = json['typeVenteCode'];
    typeBien = json['typeBien'];
    favori = json['favori'];
    typeBienCode = json['typeBienCode'];
    affichePrix = json['affichePrix'];
    prixEnBaisse = json['prixEnBaisse'];
    prixLigne1 = json['prixLigne1'];
    prixLigne2 = json['prixLigne2'];
    prixLigne3 = json['prixLigne3'];
    coupDeCoeur = json['coupDeCoeur'];
    suiviPrix = json['suiviPrix'];
    afficheCommune = json['afficheCommune'];
    contact =
        json['contact'] != null ? new Contactt.fromJson(json['contact']) : null;
    commune =
        json['commune'] != null ? new Commune.fromJson(json['commune']) : null;
    photo = json['photo'] != null ? new Photo.fromJson(json['photo']) : null;
    caracteristiques = json['caracteristiques'] != null
        ? new Caracteristiques.fromJson(json['caracteristiques'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['oidAnnonce'] = this.oidAnnonce;
    data['oidNotaire'] = this.oidNotaire;
    data['typeVente'] = this.typeVente;
    data['typeVenteCode'] = this.typeVenteCode;
    data['typeBien'] = this.typeBien;
    data['favori'] = this.favori;
    data['typeBienCode'] = this.typeBienCode;
    data['prixEnBaisse'] = this.prixEnBaisse;
    data['affichePrix'] = this.affichePrix;
    data['prixLigne1'] = this.prixLigne1;
    data['prixLigne2'] = this.prixLigne2;
    data['prixLigne3'] = this.prixLigne3;
    data['coupDeCoeur'] = this.coupDeCoeur;
    data['suiviPrix'] = this.suiviPrix;
    data['afficheCommune'] = this.afficheCommune;
    if (this.contact != null) {
      data['contact'] = this.contact.toJson();
    }
    if (this.commune != null) {
      data['commune'] = this.commune.toJson();
    }
    if (this.photo != null) {
      data['photo'] = this.photo.toJson();
    }
    if (this.caracteristiques != null) {
      data['caracteristiques'] = this.caracteristiques.toJson();
    }
    return data;
  }
}

class Commune {
  String nom;
  String codePostal;
  num latitude;
  num longitude;

  Commune({this.nom, this.codePostal, this.latitude, this.longitude});

  Commune.fromJson(Map<String, dynamic> json) {
    nom = json['nom'];
    codePostal = json['codePostal'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nom'] = this.nom;
    data['codePostal'] = this.codePostal;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class Photo {
  int count;
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

class Contactt {
  String nom;
  bool hasBareme;

  Contactt({this.nom, this.hasBareme});

  Contactt.fromJson(Map<String, dynamic> json) {
    nom = json['nom'];
    hasBareme = json['hasBareme'] == null ? false : json['hasBareme'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nom'] = this.nom;
    data['hasBareme'] = this.hasBareme;
    return data;
  }
}
