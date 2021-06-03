class CapaciteEmpruntResponse {
  double taux;
  double mensualiteSouhaitee;
  List<MontantsPret> montantsPret;
  double tauxAnnuel;

  CapaciteEmpruntResponse(
      {this.taux,
      this.mensualiteSouhaitee,
      this.montantsPret,
      this.tauxAnnuel});

  CapaciteEmpruntResponse.fromJson(Map<String, dynamic> json) {
    taux = json['taux'];
    mensualiteSouhaitee = json['mensualiteSouhaitee'];
    if (json['montantsPret'] != null) {
      montantsPret = new List<MontantsPret>();
      json['montantsPret'].forEach((v) {
        montantsPret.add(new MontantsPret.fromJson(v));
      });
    }
    tauxAnnuel = json['tauxAnnuel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['taux'] = this.taux;
    data['mensualiteSouhaitee'] = this.mensualiteSouhaitee;
    if (this.montantsPret != null) {
      data['montantsPret'] = this.montantsPret.map((v) => v.toJson()).toList();
    }
    data['tauxAnnuel'] = this.tauxAnnuel;
    return data;
  }
}

class MontantsPret {
  double montant;
  int dureeEnAnnee;
  int nbMensualite;

  MontantsPret({this.montant, this.dureeEnAnnee, this.nbMensualite});

  MontantsPret.fromJson(Map<String, dynamic> json) {
    montant = json['montant'];
    dureeEnAnnee = json['dureeEnAnnee'];
    nbMensualite = json['nbMensualite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['montant'] = this.montant;
    data['dureeEnAnnee'] = this.dureeEnAnnee;
    data['nbMensualite'] = this.nbMensualite;
    return data;
  }
}
