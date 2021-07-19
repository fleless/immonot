class NewsLetterResponse {
  num numero;
  String url;
  String titre;
  String dateCreation;
  String dateCreationLibelle;

  NewsLetterResponse(
      {this.numero,
        this.url,
        this.titre,
        this.dateCreation,
        this.dateCreationLibelle});

  NewsLetterResponse.fromJson(Map<String, dynamic> json) {
    numero = json['numero'];
    url = json['url'];
    titre = json['titre'];
    dateCreation = json['dateCreation'];
    dateCreationLibelle = json['dateCreationLibelle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['numero'] = this.numero;
    data['url'] = this.url;
    data['titre'] = this.titre;
    data['dateCreation'] = this.dateCreation;
    data['dateCreationLibelle'] = this.dateCreationLibelle;
    return data;
  }
}
