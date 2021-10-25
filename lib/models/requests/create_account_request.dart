class CreateAccountRequest {
  String backlink;
  String civilite;
  String nom;
  String prenom;
  String codePostal;
  String email;
  String password;
  String confirmPassword;
  bool subscribeNewsletterImmonot;
  bool subscribeMagazineDesNotaires;
  bool subscribeInfosPartenaires;
  String idMagazineDesNotaires;

  CreateAccountRequest(
      {this.backlink,
      this.civilite,
      this.nom,
      this.prenom,
      this.codePostal,
      this.email,
      this.password,
      this.confirmPassword,
      this.subscribeNewsletterImmonot,
      this.subscribeMagazineDesNotaires,
      this.subscribeInfosPartenaires,
      this.idMagazineDesNotaires});

  CreateAccountRequest.fromJson(Map<String, dynamic> json) {
    backlink = json['backlink'];
    civilite = json['civilite'];
    nom = json['nom'];
    prenom = json['prenom'];
    codePostal = json['codePostal'];
    email = json['email'];
    password = json['password'];
    confirmPassword = json['confirmPassword'];
    subscribeNewsletterImmonot = json['subscribeNewsletterImmonot'];
    subscribeMagazineDesNotaires = json['subscribeMagazineDesNotaires'];
    subscribeInfosPartenaires = json['subscribeInfosPartenaires'];
    idMagazineDesNotaires = json['idMagazineDesNotaires'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['backlink'] = this.backlink;
    data['civilite'] = this.civilite;
    data['nom'] = this.nom;
    data['prenom'] = this.prenom;
    data['codePostal'] = this.codePostal;
    data['email'] = this.email;
    data['password'] = this.password;
    data['confirmPassword'] = this.confirmPassword;
    data['subscribeNewsletterImmonot'] = this.subscribeNewsletterImmonot;
    data['subscribeMagazineDesNotaires'] = this.subscribeMagazineDesNotaires;
    data['subscribeInfosPartenaires'] = this.subscribeInfosPartenaires;
    data['idMagazineDesNotaires'] = this.idMagazineDesNotaires;
    return data;
  }
}
