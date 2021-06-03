class FraisNotairesResponse {
  double prix;
  double fraisActe;
  double honorairesNegoHT;
  double honorairesNegoTTC;
  double honorairesNegoTVA;
  double totalTTC;
  double fraisTresorPublic;
  double fraisTresorPublicPourcentage;
  double fraisDebours;
  double fraisDeboursPourcentage;
  double fraisNotaire;
  double fraisNotairePourcentage;

  FraisNotairesResponse(
      {this.prix,
      this.fraisActe,
      this.honorairesNegoHT,
      this.honorairesNegoTTC,
      this.honorairesNegoTVA,
      this.totalTTC,
      this.fraisTresorPublic,
      this.fraisTresorPublicPourcentage,
      this.fraisDebours,
      this.fraisDeboursPourcentage,
      this.fraisNotaire,
      this.fraisNotairePourcentage});

  FraisNotairesResponse.fromJson(Map<String, dynamic> json) {
    prix = json['prix'];
    fraisActe = json['fraisActe'];
    honorairesNegoHT = json['honorairesNegoHT'];
    honorairesNegoTTC = json['honorairesNegoTTC'];
    honorairesNegoTVA = json['honorairesNegoTVA'];
    totalTTC = json['totalTTC'];
    fraisTresorPublic = json['fraisTresorPublic'];
    fraisTresorPublicPourcentage = json['fraisTresorPublicPourcentage'];
    fraisDebours = json['fraisDebours'];
    fraisDeboursPourcentage = json['fraisDeboursPourcentage'];
    fraisNotaire = json['fraisNotaire'];
    fraisNotairePourcentage = json['fraisNotairePourcentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['prix'] = this.prix;
    data['fraisActe'] = this.fraisActe;
    data['honorairesNegoHT'] = this.honorairesNegoHT;
    data['honorairesNegoTTC'] = this.honorairesNegoTTC;
    data['honorairesNegoTVA'] = this.honorairesNegoTVA;
    data['totalTTC'] = this.totalTTC;
    data['fraisTresorPublic'] = this.fraisTresorPublic;
    data['fraisTresorPublicPourcentage'] = this.fraisTresorPublicPourcentage;
    data['fraisDebours'] = this.fraisDebours;
    data['fraisDeboursPourcentage'] = this.fraisDeboursPourcentage;
    data['fraisNotaire'] = this.fraisNotaire;
    data['fraisNotairePourcentage'] = this.fraisNotairePourcentage;
    return data;
  }
}
