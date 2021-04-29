import 'package:immonot/models/responses/places_response.dart';

class FilterModels {
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

  FilterModels() {
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
  }

  clear(){
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
  }
}
