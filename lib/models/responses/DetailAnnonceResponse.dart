class DetailAnnonceResponse {
  String oidAnnonce;
  String oidNotaire;
  String typeVente;
  String typeVenteCode;
  String typeBien;
  String typeBienCode;
  String titre;
  String descriptif;
  String refClient;
  String lienImmonot;
  bool favori;
  bool suiviPrix;
  bool coupDeCoeur;
  bool prixEnBaisse;
  bool affichePrix;
  String prixLigne1;
  String prixLigne2;
  String prixLigne3;
  bool afficheCommune;
  Commune commune;
  String quartier;
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
      this.refClient,
      this.lienImmonot,
      this.favori,
      this.descriptif,
      this.coupDeCoeur,
      this.suiviPrix,
      this.prixEnBaisse,
      this.affichePrix,
      this.prixLigne1,
      this.prixLigne2,
      this.prixLigne3,
      this.afficheCommune,
      this.commune,
      this.quartier,
      this.photo,
      this.caracteristiques,
      this.energie,
      this.contact,
      this.copropriete});

  DetailAnnonceResponse.fromJson(Map<String, dynamic> json) {
    oidAnnonce = json['oidAnnonce'];
    oidNotaire = json['oidNotaire'];
    typeVente = json['typeVente'];
    typeVenteCode = json['typeVenteCode'];
    typeBien = json['typeBien'];
    typeBienCode = json['typeBienCode'];
    refClient = json['refClient'];
    lienImmonot = json['lienImmonot'];
    titre = json['titre'];
    favori = json['favori'];
    descriptif = json['descriptif'];
    coupDeCoeur = json['coupDeCoeur'];
    suiviPrix = json['suiviPrix'];
    prixEnBaisse = json['prixEnBaisse'];
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
    quartier = json['quartier'] != null ? json['quartier'] : null;
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
    data['favori'] = this.favori;
    data['descriptif'] = this.descriptif;
    data['coupDeCoeur'] = this.coupDeCoeur;
    data['suiviPrix'] = this.suiviPrix;
    data['quartier'] = this.quartier;
    data['refClient'] = this.refClient;
    data['lienImmonot'] = this.lienImmonot;
    data['prixEnBaisse'] = this.prixEnBaisse;
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
  num nbTetes;
  List<String> typeChauffage;
  List<Complements> complements;

  Caracteristiques(
      {this.nbPieces,
      this.nbChambres,
      this.surfaceHabitable,
      this.surfaceTerrain,
      this.complements,
      this.nbTetes,
      this.typeChauffage});

  Caracteristiques.fromJson(Map<String, dynamic> json) {
    nbPieces = json['nbPieces'];
    nbChambres = json['nbChambres'];
    surfaceHabitable = json['surfaceHabitable'];
    surfaceTerrain = json['surfaceTerrain'];
    nbTetes = json['nbTetes'] == null ? 0 : json['nbTetes'];
    if (json['typeChauffage'] != null) {
      typeChauffage = json['typeChauffage'].cast<String>();
    }
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
    if (this.typeChauffage != null) {
      data['typeChauffage'] = this.typeChauffage.map((v) => v).toList();
    }
    if (this.complements != null) {
      data['complements'] = this.complements.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Complements {
  String key;
  String label;
  dynamic value;

  Complements({this.key, this.label, this.value});

  Complements.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['label'] = this.label;
    data['value'] = this.value;
    return data;
  }
}

class Energie {
  bool diagnosticEtabli;
  bool vierge;
  bool exempte;
  String dateDiagnostic;
  num energie;
  String energieNote;
  String energieEtiquette;
  num ges;
  String gesNote;
  String gesEtiquette;
  num coutEnergieMin;
  num coutEnergieMax;
  String coutEnergieMention;

  Energie(
      {this.diagnosticEtabli,
      this.vierge,
      this.exempte,
      this.dateDiagnostic,
      this.energie,
      this.energieNote,
      this.energieEtiquette,
      this.ges,
      this.gesNote,
      this.gesEtiquette,
      this.coutEnergieMin,
      this.coutEnergieMax,
      this.coutEnergieMention});

  Energie.fromJson(Map<String, dynamic> json) {
    diagnosticEtabli = json['diagnosticEtabli'];
    vierge = json['vierge'];
    exempte = json['exempte'];
    dateDiagnostic = json['dateDiagnostic'];
    energie = json['energie'];
    energieNote = json['energieNote'];
    energieEtiquette = json['energieEtiquette'];
    ges = json['ges'];
    gesNote = json['gesNote'];
    gesEtiquette = json['gesEtiquette'];
    coutEnergieMin = json['coutEnergieMin'];
    coutEnergieMax = json['coutEnergieMax'];
    coutEnergieMention = json['coutEnergieMention'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['diagnosticEtabli'] = this.diagnosticEtabli;
    data['vierge'] = this.vierge;
    data['exempte'] = this.exempte;
    data['dateDiagnostic'] = this.dateDiagnostic;
    data['energie'] = this.energie;
    data['energieNote'] = this.energieNote;
    data['energieEtiquette'] = this.energieEtiquette;
    data['ges'] = this.ges;
    data['gesNote'] = this.gesNote;
    data['gesEtiquette'] = this.gesEtiquette;
    data['coutEnergieMin'] = this.coutEnergieMin;
    data['coutEnergieMax'] = this.coutEnergieMax;
    data['coutEnergieMention'] = this.coutEnergieMention;
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
  bool hasBareme;

  Contact(
      {this.nom,
      this.adresse,
      this.codePostal,
      this.ville,
      this.tel,
      this.website,
      this.siret,
      this.tvaIntraCommunautaire,
      this.hasBareme});

  Contact.fromJson(Map<String, dynamic> json) {
    nom = json['nom'];
    adresse = json['adresse'];
    codePostal = json['codePostal'];
    ville = json['ville'];
    tel = json['tel'];
    website = json['website'];
    siret = json['siret'];
    tvaIntraCommunautaire = json['tvaIntraCommunautaire'];
    hasBareme = json['hasBareme'] == null ? false : json['hasBareme'];
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
    data['hasBareme'] = this.hasBareme;
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
