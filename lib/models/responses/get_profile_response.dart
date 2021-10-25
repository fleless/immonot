class GetProfileResponse {
  num oidInternaute;
  String civilite;
  String nom;
  String prenom;
  String codePostal;
  String telephone;
  String dateDerniereConnexion;
  String dateInscription;
  String mail;
  bool emailValide;
  String souhaite;
  bool estVendeur;
  bool subscribeMagazineDesNotaires;
  bool subscribeInfosPartenairesImmonot;
  bool subscribeInfosPartenairesMdn;
  bool subscribeNewsletterImmonot;

  GetProfileResponse(
      {this.oidInternaute,
      this.civilite,
      this.nom,
      this.prenom,
      this.codePostal,
      this.telephone,
      this.dateDerniereConnexion,
      this.dateInscription,
      this.mail,
      this.emailValide,
      this.souhaite,
      this.estVendeur,
      this.subscribeMagazineDesNotaires,
      this.subscribeInfosPartenairesImmonot,
      this.subscribeInfosPartenairesMdn,
      this.subscribeNewsletterImmonot});

  GetProfileResponse.fromJson(Map<String, dynamic> json) {
    oidInternaute = json['oidInternaute'];
    civilite = json['civilite'];
    nom = json['nom'];
    prenom = json['prenom'];
    codePostal = json['codePostal'];
    telephone = json['telephone'];
    dateDerniereConnexion = json['dateDerniereConnexion'];
    dateInscription = json['dateInscription'];
    mail = json['mail'];
    emailValide = json['emailValide'];
    souhaite = json['souhaite'];
    estVendeur = json['estVendeur'];
    subscribeMagazineDesNotaires = json['subscribeMagazineDesNotaires'];
    subscribeInfosPartenairesImmonot = json['subscribeInfosPartenairesImmonot'];
    subscribeInfosPartenairesMdn = json['subscribeInfosPartenairesMdn'];
    subscribeNewsletterImmonot = json['subscribeNewsletterImmonot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['oidInternaute'] = this.oidInternaute;
    data['civilite'] = this.civilite;
    data['nom'] = this.nom;
    data['prenom'] = this.prenom;
    data['codePostal'] = this.codePostal;
    data['telephone'] = this.telephone;
    data['dateDerniereConnexion'] = this.dateDerniereConnexion;
    data['dateInscription'] = this.dateInscription;
    data['mail'] = this.mail;
    data['emailValide'] = this.emailValide;
    data['souhaite'] = this.souhaite;
    data['estVendeur'] = this.estVendeur;
    data['subscribeMagazineDesNotaires'] = this.subscribeMagazineDesNotaires;
    data['subscribeInfosPartenairesImmonot'] =
        this.subscribeInfosPartenairesImmonot;
    data['subscribeInfosPartenairesMdn'] = this.subscribeInfosPartenairesMdn;
    data['subscribeNewsletterImmonot'] = this.subscribeNewsletterImmonot;
    return data;
  }
}
