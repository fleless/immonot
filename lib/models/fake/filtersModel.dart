import 'package:immonot/models/enum/type_biens.dart';
import 'package:immonot/models/enum/type_ventes.dart';
import 'package:immonot/models/responses/places_response.dart';

class FilterModels {
  String nom;
  String commentaire;
  List<PlacesResponse> listPlaces;
  double rayon;
  List<TypeVentesEnumeration> listTypeVente;
  List<TypeBienEnumeration> listtypeDeBien;
  double priceMin;
  double priceMax;
  double surInterieurMin;
  double surInterieurMax;
  double surExterieurMin;
  double surExterieurMax;
  double piecesMin;
  double piecesMax;
  double chambresMin;
  double chambresMax;
  String reference;
  bool notificationsOn;
  bool emailOn;
  bool vendeur;

  FilterModels() {
    this.nom = "";
    this.commentaire = "";
    this.listPlaces = <PlacesResponse>[];
    this.rayon = 0;
    this.listTypeVente = <TypeVentesEnumeration>[];
    this.listtypeDeBien = <TypeBienEnumeration>[];
    this.priceMax = 0;
    this.priceMin = 0;
    this.surExterieurMax = 0;
    this.surExterieurMin = 0;
    this.surInterieurMax = 0;
    this.surInterieurMin = 0;
    this.piecesMax = 0;
    this.piecesMin = 0;
    this.chambresMax = 0;
    this.chambresMin = 0;
    this.reference = "";
    this.notificationsOn = true;
    this.emailOn = true;
    this.vendeur = false;
  }

  clear() {
    this.nom = "";
    this.commentaire = "";
    this.listPlaces = <PlacesResponse>[];
    this.rayon = 0;
    this.listTypeVente = <TypeVentesEnumeration>[];
    this.listtypeDeBien = <TypeBienEnumeration>[];
    this.priceMax = 0;
    this.priceMin = 0;
    this.surExterieurMax = 0;
    this.surExterieurMin = 0;
    this.surInterieurMax = 0;
    this.surInterieurMin = 0;
    this.piecesMax = 0;
    this.piecesMin = 0;
    this.chambresMax = 0;
    this.chambresMin = 0;
    this.reference = "";
    this.notificationsOn = true;
    this.emailOn = true;
    this.vendeur = false;
  }

  FilterModels.fromJson(Map<String, dynamic> json) {
    priceMin = json['priceMin'];
    priceMax = json['priceMax'];
    surInterieurMin = json['surInterieurMin'];
    surInterieurMax = json['surInterieurMax'];
    surExterieurMin = json['surExterieurMin'];
    surExterieurMax = json['surExterieurMax'];
    chambresMin = json['chambresMin'];
    chambresMax = json['chambresMax'];
    piecesMax = json['piecesMax'];
    piecesMin = json['piecesMin'];
    reference = json['reference'];
    if (json['listtypeDeBien'] != null) {
      listtypeDeBien = <TypeBienEnumeration>[];
      json['listtypeDeBien'].forEach((v) {
        if (v == null) {
        } else {
          listtypeDeBien.add(new TypeBienEnumeration.fromJson(v));
        }
      });
    }
    if (json['listTypeVente'] != null) {
      listTypeVente = <TypeVentesEnumeration>[];
      json['listTypeVente'].forEach((v) {
        if (v == null) {
        } else {
          listTypeVente.add(new TypeVentesEnumeration.fromJson(v));
        }
      });
    }
    if (json['listPlaces'] != null) {
      listPlaces = <PlacesResponse>[];
      json['listPlaces'].forEach((v) {
        if (v == null) {
        } else {
          listPlaces.add(new PlacesResponse.fromJson(v));
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['priceMin'] = this.priceMin;
    data['priceMax'] = this.priceMax;
    data['surInterieurMin'] = this.surInterieurMin;
    data['surInterieurMax'] = this.surInterieurMax;
    data['surExterieurMin'] = this.surExterieurMin;
    data['surExterieurMax'] = this.surExterieurMax;
    data['chambresMin'] = this.chambresMin;
    data['chambresMax'] = this.chambresMax;
    data['piecesMax'] = this.piecesMax;
    data['piecesMin'] = this.piecesMin;
    data['reference'] = this.reference;
    if (this.listtypeDeBien != null) {
      data['listtypeDeBien'] =
          this.listtypeDeBien.map((v) => v.toJson()).toList();
    }
    if (this.listTypeVente != null) {
      data['listTypeVente'] =
          this.listTypeVente.map((v) => v.toJson()).toList();
    }
    if (this.listPlaces != null) {
      data['listPlaces'] = this.listPlaces.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
