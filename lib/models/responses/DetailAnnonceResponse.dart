class DetailAnnonceResponse {
  String oidAnnonce;
  String oidNotaire;
  String typeVente;
  String typeVenteCode;
  String typeBien;
  String typeBienCode;
  String titre;
  String descriptif;
  bool coupDeCoeur;
  bool affichePrix;
  String prixLigne1;
  String prixLigne2;
  String prixLigne3;
  bool afficheCommune;
  Commune commune;
  Photo photo;
  Caracteristiques caracteristiques;
  Energie energie;
  Contact contact;
  Copropriete copropriete;

  DetailAnnonceResponse(
      {this.oidAnnonce,
      this.oidNotaire,
      this.typeVente,
      this.typeVenteCode,
      this.typeBien,
      this.typeBienCode,
      this.titre,
      this.descriptif,
      this.coupDeCoeur,
      this.affichePrix,
      this.prixLigne1,
      this.prixLigne2,
      this.prixLigne3,
      this.afficheCommune,
      this.commune,
      this.photo,
      this.caracteristiques,
      this.energie,
      this.contact});

  DetailAnnonceResponse.fromJson(Map<String, dynamic> json) {
    oidAnnonce = json['oidAnnonce'];
    oidNotaire = json['oidNotaire'];
    typeVente = json['typeVente'];
    typeVenteCode = json['typeVenteCode'];
    typeBien = json['typeBien'];
    typeBienCode = json['typeBienCode'];
    titre = json['titre'];
    descriptif = json['descriptif'];
    coupDeCoeur = json['coupDeCoeur'];
    affichePrix = json['affichePrix'];
    prixLigne1 = json['prixLigne1'];
    prixLigne2 = json['prixLigne2'];
    prixLigne3 = json['prixLigne3'];
    afficheCommune = json['afficheCommune'];
    copropriete = json['copropriete'] != null
        ? new Copropriete.fromJson(json['copropriete'])
        : null;
    commune =
        json['commune'] != null ? new Commune.fromJson(json['commune']) : null;
    photo = json['photo'] != null ? new Photo.fromJson(json['photo']) : null;
    caracteristiques = json['caracteristiques'] != null
        ? new Caracteristiques.fromJson(json['caracteristiques'])
        : null;
    energie =
        json['energie'] != null ? new Energie.fromJson(json['energie']) : null;
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
    data['titre'] = this.titre;
    data['descriptif'] = this.descriptif;
    data['coupDeCoeur'] = this.coupDeCoeur;
    data['affichePrix'] = this.affichePrix;
    data['prixLigne1'] = this.prixLigne1;
    data['prixLigne2'] = this.prixLigne2;
    data['prixLigne3'] = this.prixLigne3;
    data['afficheCommune'] = this.afficheCommune;
    if (this.copropriete != null) {
      data['copropriete'] = this.copropriete.toJson();
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
    if (this.energie != null) {
      data['energie'] = this.energie.toJson();
    }
    if (this.contact != null) {
      data['contact'] = this.contact.toJson();
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
  String principale;
  String principaleThumb;
  List<Galerie> galerie;

  Photo({this.principale, this.principaleThumb, this.galerie});

  Photo.fromJson(Map<String, dynamic> json) {
    principale = json['principale'];
    principaleThumb = json['principaleThumb'];
    if (json['galerie'] != null) {
      galerie = new List<Galerie>();
      json['galerie'].forEach((v) {
        if (v == null) {
        } else {
          galerie.add(new Galerie.fromJson(v));
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['principale'] = this.principale;
    data['principaleThumb'] = this.principaleThumb;
    if (this.galerie != null) {
      data['galerie'] = this.galerie.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Galerie {
  String img;
  String thumb;

  Galerie({this.img, this.thumb});

  Galerie.fromJson(Map<String, dynamic> json) {
    img = json['img'];
    thumb = json['thumb'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img'] = this.img;
    data['thumb'] = this.thumb;
    return data;
  }
}

class Caracteristiques {
  num nbPieces;
  num nbChambres;
  num surfaceHabitable;
  num surfaceTerrain;
  List<Complements> complements;

  Caracteristiques(
      {this.nbPieces,
      this.nbChambres,
      this.surfaceHabitable,
      this.surfaceTerrain,
      this.complements});

  Caracteristiques.fromJson(Map<String, dynamic> json) {
    nbPieces = json['nbPieces'];
    nbChambres = json['nbChambres'];
    surfaceHabitable = json['surfaceHabitable'];
    surfaceTerrain = json['surfaceTerrain'];
    if (json['complements'] != null) {
      complements = new List<Complements>();
      json['complements'].forEach((v) {
        complements.add(new Complements.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nbPieces'] = this.nbPieces;
    data['nbChambres'] = this.nbChambres;
    data['surfaceHabitable'] = this.surfaceHabitable;
    data['surfaceTerrain'] = this.surfaceTerrain;
    if (this.complements != null) {
      data['complements'] = this.complements.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Complements {
  String key;
  dynamic value;

  Complements({this.key, this.value});

  Complements.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    return data;
  }
}

class Energie {
  bool diagnosticEtabli;
  bool vierge;
  bool exempte;
  num energie;
  String energieNote;
  String energieEtiquette;
  num ges;
  String gesNote;
  String gesEtiquette;

  Energie(
      {this.diagnosticEtabli,
      this.vierge,
      this.exempte,
      this.energie,
      this.energieNote,
      this.energieEtiquette,
      this.ges,
      this.gesNote,
      this.gesEtiquette});

  Energie.fromJson(Map<String, dynamic> json) {
    diagnosticEtabli = json['diagnosticEtabli'];
    vierge = json['vierge'];
    exempte = json['exempte'];
    energie = json['energie'];
    energieNote = json['energieNote'];
    energieEtiquette = json['energieEtiquette'];
    ges = json['ges'];
    gesNote = json['gesNote'];
    gesEtiquette = json['gesEtiquette'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['diagnosticEtabli'] = this.diagnosticEtabli;
    data['vierge'] = this.vierge;
    data['exempte'] = this.exempte;
    data['energie'] = this.energie;
    data['energieNote'] = this.energieNote;
    data['energieEtiquette'] = this.energieEtiquette;
    data['ges'] = this.ges;
    data['gesNote'] = this.gesNote;
    data['gesEtiquette'] = this.gesEtiquette;
    return data;
  }
}

class Contact {
  String nom;
  String adresse;
  String codePostal;
  String ville;
  String tel;
  String website;
  String siret;
  String tvaIntraCommunautaire;

  Contact(
      {this.nom,
      this.adresse,
      this.codePostal,
      this.ville,
      this.tel,
      this.website,
      this.siret,
      this.tvaIntraCommunautaire});

  Contact.fromJson(Map<String, dynamic> json) {
    nom = json['nom'];
    adresse = json['adresse'];
    codePostal = json['codePostal'];
    ville = json['ville'];
    tel = json['tel'];
    website = json['website'];
    siret = json['siret'];
    tvaIntraCommunautaire = json['tvaIntraCommunautaire'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nom'] = this.nom;
    data['adresse'] = this.adresse;
    data['codePostal'] = this.codePostal;
    data['ville'] = this.ville;
    data['tel'] = this.tel;
    data['website'] = this.website;
    data['siret'] = this.siret;
    data['tvaIntraCommunautaire'] = this.tvaIntraCommunautaire;
    return data;
  }
}

class Copropriete {
  num montantCharge;
  num nbLot;
  bool procedure;

  Copropriete({this.montantCharge, this.nbLot, this.procedure});

  Copropriete.fromJson(Map<String, dynamic> json) {
    montantCharge = json['montantCharge'];
    nbLot = json['nbLot'];
    procedure = json['procedure'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['montantCharge'] = this.montantCharge;
    data['nbLot'] = this.nbLot;
    data['procedure'] = this.procedure;
    return data;
  }
}
