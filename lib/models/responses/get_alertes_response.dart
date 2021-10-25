import 'package:immonot/models/requests/create_alerte_request.dart';

class GetAlertesResponse {
  num totalElements;
  num totalPages;
  num number;
  num size;
  List<Content> content;
  num numberOfElements;
  bool first;
  bool last;
  bool empty;

  GetAlertesResponse(
      {this.totalElements,
      this.totalPages,
      this.number,
      this.size,
      this.content,
      this.numberOfElements,
      this.first,
      this.last,
      this.empty});

  GetAlertesResponse.fromJson(Map<String, dynamic> json) {
    totalElements = json['totalElements'];
    totalPages = json['totalPages'];
    number = json['number'];
    size = json['size'];
    if (json['content'] != null) {
      content = new List<Content>();
      json['content'].forEach((v) {
        content.add(new Content.fromJson(v));
      });
    }
    numberOfElements = json['numberOfElements'];
    first = json['first'];
    last = json['last'];
    empty = json['empty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalElements'] = this.totalElements;
    data['totalPages'] = this.totalPages;
    data['number'] = this.number;
    data['size'] = this.size;
    if (this.content != null) {
      data['content'] = this.content.map((v) => v.toJson()).toList();
    }
    data['numberOfElements'] = this.numberOfElements;
    data['first'] = this.first;
    data['last'] = this.last;
    data['empty'] = this.empty;
    return data;
  }
}

class Content {
  num id;
  num idInternaute;
  bool active;
  String nom;
  String commentaire;
  bool push;
  bool mail;
  String action;
  String frequence;
  String frequenceLabel;
  String dateDernierEnvoi;
  String dateCreation;
  Recherche recherche;

  Content(
      {this.id,
      this.idInternaute,
      this.active,
      this.nom,
      this.commentaire,
      this.push,
      this.mail,
      this.action,
      this.frequence,
      this.frequenceLabel,
      this.dateDernierEnvoi,
      this.dateCreation,
      this.recherche});

  Content.fromJson(Map<String, dynamic> json) {
    id = json['id'] == null ? null : json['id'];
    idInternaute = json['idInternaute'] == null ? null : json['idInternaute'];
    active = json['active'] == null ? null : json['active'];
    nom = json['nom'] == null ? null : json['nom'];
    commentaire = json['commentaire'] == null ? null : json['commentaire'];
    push = json['push'] == null ? null : json['push'];
    mail = json['mail'] == null ? null : json['mail'];
    action = json['action'] == null ? null : json['action'];
    frequence = json['frequence'] == null ? null : json['frequence'];
    frequenceLabel =
        json['frequenceLabel'] == null ? null : json['frequenceLabel'];
    dateDernierEnvoi =
        json['dateDernierEnvoi'] == null ? null : json['dateDernierEnvoi'];
    dateCreation = json['dateCreation'] == null ? null : json['dateCreation'];
    recherche = json['recherche'] != null
        ? new Recherche.fromJson(json['recherche'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = data['id'] == null ? null : this.id;
    data['idInternaute'] =
        data['idInternaute'] == null ? null : this.idInternaute;
    data['active'] = data['active'] == null ? null : this.active;
    data['nom'] = data['nom'] == null ? null : this.nom;
    data['commentaire'] = data['commentaire'] == null ? null : this.commentaire;
    data['push'] = data['push'] == null ? null : this.push;
    data['mail'] = data['mail'] == null ? null : this.mail;
    data['action'] = data['action'] == null ? null : this.action;
    data['frequence'] = data['frequence'] == null ? null : this.frequence;
    data['frequenceLabel'] =
        data['frequenceLabel'] == null ? null : this.frequenceLabel;
    data['dateDernierEnvoi'] =
        data['dateDernierEnvoi'] == null ? null : this.dateDernierEnvoi;
    data['dateCreation'] =
        data['dateCreation'] == null ? null : this.dateCreation;
    if (this.recherche != null) {
      data['recherche'] = this.recherche.toJson();
    }
    return data;
  }
}
