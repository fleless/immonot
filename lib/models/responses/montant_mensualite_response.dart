class MontantMensualiteResponse {
  double montantPret;
  double tauxInteret;
  int dureeEnAnnee;
  double remboursementMensuel;
  double coutTotalEmprunt;
  List<TableauAmortissement> tableauAmortissement;
  double coutTauxInteret;
  int nbMensualite;
  double tauxAnnuel;

  MontantMensualiteResponse(
      {this.montantPret,
      this.tauxInteret,
      this.dureeEnAnnee,
      this.remboursementMensuel,
      this.coutTotalEmprunt,
      this.tableauAmortissement,
      this.coutTauxInteret,
      this.nbMensualite,
      this.tauxAnnuel});

  MontantMensualiteResponse.fromJson(Map<String, dynamic> json) {
    montantPret = json['montantPret'];
    tauxInteret = json['tauxInteret'];
    dureeEnAnnee = json['dureeEnAnnee'];
    remboursementMensuel = json['remboursementMensuel'];
    coutTotalEmprunt = json['coutTotalEmprunt'];
    if (json['tableauAmortissement'] != null) {
      tableauAmortissement = new List<TableauAmortissement>();
      json['tableauAmortissement'].forEach((v) {
        tableauAmortissement.add(new TableauAmortissement.fromJson(v));
      });
    }
    coutTauxInteret = json['coutTauxInteret'];
    nbMensualite = json['nbMensualite'];
    tauxAnnuel = json['tauxAnnuel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['montantPret'] = this.montantPret;
    data['tauxInteret'] = this.tauxInteret;
    data['dureeEnAnnee'] = this.dureeEnAnnee;
    data['remboursementMensuel'] = this.remboursementMensuel;
    data['coutTotalEmprunt'] = this.coutTotalEmprunt;
    if (this.tableauAmortissement != null) {
      data['tableauAmortissement'] =
          this.tableauAmortissement.map((v) => v.toJson()).toList();
    }
    data['coutTauxInteret'] = this.coutTauxInteret;
    data['nbMensualite'] = this.nbMensualite;
    data['tauxAnnuel'] = this.tauxAnnuel;
    return data;
  }
}

class TableauAmortissement {
  int echeance;
  double mensualite;
  double capitalRembourse;
  double interet;
  double capitalRestant;

  TableauAmortissement(
      {this.echeance,
      this.mensualite,
      this.capitalRembourse,
      this.interet,
      this.capitalRestant});

  TableauAmortissement.fromJson(Map<String, dynamic> json) {
    echeance = json['echeance'];
    mensualite = json['mensualite'];
    capitalRembourse = json['capitalRembourse'];
    interet = json['interet'];
    capitalRestant = json['capitalRestant'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['echeance'] = this.echeance;
    data['mensualite'] = this.mensualite;
    data['capitalRembourse'] = this.capitalRembourse;
    data['interet'] = this.interet;
    data['capitalRestant'] = this.capitalRestant;
    return data;
  }
}
