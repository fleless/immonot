import 'package:immonot/models/responses/places_response.dart';

class FilterModels {
  String nom;
  String commentaire;
  List<PlacesResponse> listPlaces;
  double rayon;
  List<String> listTransactions;
  List<String> listtypeDeBien;
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
    this.listTransactions = <String>[];
    this.listtypeDeBien = <String>[];
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

  clear(){
    this.nom = "";
    this.commentaire = "";
    this.listPlaces = <PlacesResponse>[];
    this.rayon = 0;
    this.listTransactions = <String>[];
    this.listtypeDeBien = <String>[];
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
}
